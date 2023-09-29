import 'package:flutter/material.dart';
import 'package:orginone/dart/base/common/commands.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/dart/core/thing/directory.dart';
import 'package:orginone/dart/core/thing/fileinfo.dart';
import 'package:orginone/dart/core/work/index.dart';
import 'package:orginone/main.dart';

abstract class IApplication implements IStandardFileInfo<XApplication> {
  ///上级模块
  IApplication? parent;

  ///下级模块
  late List<IApplication> children;

  ///流程定义
  late List<IWork> works;

  ///加载办事
  Future<List<IWork>> loadWorks({bool reload = false});

  ///新建办事
  Future<IWork?> createWork(WorkDefineModel data);

  ///新建模块
  Future<IApplication?> createModule(ApplicationModel data);

  ///接收模块变更消息
  Future<bool> receiveMessage(String operate, XApplication data);
}

class Application extends StandardFileInfo<XApplication>
    implements IApplication {
  @override
  final XApplication metadata;
  @override
  final IDirectory directory;

  final List<XApplication>? applications;

  Application(this.metadata, this.directory, {this.parent, this.applications})
      : super(
          metadata,
          directory,
          directory.resource.applicationColl,
        ) {
    isContainer = true;
    loadChildren(applications);
  }

  @override
  late List<IWork> works = [];
  @override
  late List<IApplication> children = [];

  @override
  IApplication? parent;

  final bool _worksLoaded = false;
  @override
  String get locationKey => key;

  @override
  List<IFileInfo<XEntity>> content(int mode) {
    final List<IFileInfo<XEntity>> fileList = [...children, ...works];
    fileList.sort((a, b) => DateTime.parse(a.metadata.updateTime ?? "")
        .compareTo(DateTime.parse(b.metadata.updateTime ?? "")));
    return fileList.reversed.toList();
  }

  structCallback() {
    command.emitter('-', 'refresh', [this]);
  }

  @override
  Future<bool> copy(IDirectory destination) async {
    if (destination.id != directory.id) {
      var data = ApplicationModel.fromJson(metadata.toJson());
      data.directoryId = directory.id;
      var res = await destination.createApplication(data);
      return res != null;
    }
    return false;
  }

  @override
  Future<bool> move(IDirectory destination) async {
    if (parent != null && allowMove(destination)) {
      List<XApplication> applications = _getChildren(this);
      applications.map((e) => e.directoryId = destination.id).toList();
      var data =
          await destination.resource.applicationColl.replaceMany(applications);
      if (data.isNotEmpty) {
        StandardFileInfo fileInfo =
            StandardFileInfo(metadata, super.directory, _coll);
        await fileInfo.notify('refresh', [directory.metadata]);
        await destination.notify('refresh', [destination.metadata]);
      }
    }
    return false;

    if (parent != null && allowMove(destination)) {
      var success = await update(ApplicationModel.fromJson(metadata.toJson()));
      if (success) {
        directory.applications.removeWhere((i) => i.id == id);
        directory = destination;
        destination.applications.add(this);
      }
      return success;
    }
    return false;
  }

  @override
  Future<bool> delete() async {
    var res = await kernel.deleteApplication(IdReq(id: id));
    if (res.success) {
      directory.applications.removeWhere((i) => i.id == id);
    }
    return res.success;
  }

  @override
  Future<IWork?> createWork(WorkDefineModel data) async {
    data.applicationId = id;
    var res = await kernel.createWorkDefine(data);
    if (res.success && res.data != null) {
      var work = Work(res.data!, this);
      works.add(work);
      return work;
    }
    return null;
  }

  @override
  Future<List<IWork>> loadWorks({bool reload = false}) async {
    if (works.isEmpty || reload) {
      var res = await kernel.queryWorkDefine(IdReq(id: id));
      if (res.success && res.data != null) {
        works = res.data!.result?.map((a) => Work(a, this)).toList() ?? [];
      }
    }
    return works;
  }

  @override
  Future<bool> rename(String name) async {
    var data = ApplicationModel.fromJson(metadata.toJson());
    data.name = name;
    return await update(data);
  }

  @override
  Future<bool> update(ApplicationModel data) async {
    data.id = id;
    data.directoryId = metadata.directoryId;
    data.typeName = metadata.typeName!;
    var res = await kernel.updateApplication(data);
    return res.success;
  }

  @override
  Future<bool> loadContent({bool reload = false}) async {
    await loadWorks(reload: reload);
    return true;
  }

  void loadChildren(List<XApplication>? applications) {
    if (applications != null && applications.isNotEmpty) {
      applications.where((i) => i.parentId == id).forEach((i) {
        children.add(Application(i, directory, this, applications));
      });
    }
  }

  List<XApplication> _getChildren(IApplication application) {
    List<XApplication> applications = [application.metadata];

    for (var child in application.children) {
      applications.add(child.metadata);
      applications.addAll(_getChildren(child));
    }

    return applications;
  }

  @override
  // TODO: implement popupMenuItem
  List<PopupMenuItem> get popupMenuItem {
    {
      List<PopupMenuKey> key = [];
      key.addAll([
        PopupMenuKey.updateInfo,
        PopupMenuKey.rename,
        PopupMenuKey.delete,
        PopupMenuKey.shareQr,
      ]);
      return key
          .map((e) => PopupMenuItem(
                value: e,
                child: Text(e.label),
              ))
          .toList();
    }
  }

  @override
  bool isLoaded = false;

  @override
  Future<IApplication?> createModule(ApplicationModel data) async {
    data.parentId = id;
    data.typeName = '模块';
    data.directoryId = directory.id;
    final res = await kernel.createApplication(data);
    if (res.success && res.data != null) {
      final application = Application(res.data!, directory, this);
      children.add(application);
      return application;
    }
    return null;
  }

  @override
  Future<bool> receiveMessage(String operate, XApplication data) {
    // TODO: implement receiveMessage
    throw UnimplementedError();
  }

  @override
  bool allowCopy(IDirectory destination) {
    return directory.target.belongId != destination.target.belongId;
  }

  @override
  bool allowMove(IDirectory destination) {
    return (destination.id != directory.id &&
        destination.target.belongId == directory.target.belongId);
  }

  @override
  late bool isContainer;
}
