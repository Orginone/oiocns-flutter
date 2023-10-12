import 'dart:async';

import 'package:orginone/dart/base/common/commands.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/public/consts.dart';
import 'package:orginone/dart/core/public/operates.dart';
import 'package:orginone/dart/core/thing/directory.dart';
import 'package:orginone/dart/core/thing/fileinfo.dart';
import 'package:orginone/dart/core/work/index.dart';
import 'package:orginone/main.dart';

abstract class IApplication implements IStandardFileInfo<XApplication> {
  ///上级模块
  IApplication? parent;

  ///下级模块
  late final List<IApplication> children;

  ///流程定义
  late final List<IWork> works;

  ///加载办事
  Future<List<IWork>> loadWorks({bool reload = false});

  ///新建办事
  Future<IWork?> createWork(WorkDefineModel data);

  ///新建模块
  Future<XApplication?> createModule(XApplication data);

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

  @override
  late List<IWork> works = [];
  @override
  late List<IApplication> children = [];

  @override
  IApplication? parent;

  final bool _worksLoaded = false;
  @override
  String get locationKey => 'applications';
  @override
  String get cacheFlag => key;
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
  List<IFileInfo<XEntity>> content({int? mode}) {
    final List<IFileInfo<XEntity>> fileList = [...children, ...works];
    fileList.sort((a, b) => DateTime.parse(a.metadata.updateTime ?? "")
        .compareTo(DateTime.parse(b.metadata.updateTime ?? "")));
    return fileList.reversed.toList();
  }

  structCallback() {
    command.emitter('-', 'refresh', [this]);
  }

  @override
  Future<bool> move(IDirectory destination) async {
    if (parent != null && allowMove(destination)) {
      final applications = getChildren(this);

      final data = await destination.resource.applicationColl
          .replaceMany(applications.map((a) {
        a.directoryId = destination.id;
        return a;
      }).toList());
      if (data.isNotEmpty) {
        await notify('refresh', [directory.metadata]);
        await destination.notify('refresh', [destination.metadata]);
      }
    }
    return false;
  }

  @override
  Future<bool> delete() async {
    final success = await directory.resource.applicationColl.deleteMany(
      getChildren(this),
    );
    if (success) {
      return await super.delete();
    }
    return success;
  }

  @override
  Future<List<IWork>> loadWorks({bool reload = false}) async {
    if (works.isEmpty || reload) {
      var res =
          await kernel.queryWorkDefine(IdPageModel(id: id, page: pageAll));
      if (res.success && res.data != null) {
        works = (res.data!.result).map((a) => Work(a, this)).toList();
      }
    }
    return works;
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
  Future<XApplication?> createModule(XApplication data) async {
    data.parentId = id;
    data.typeName = '模块';
    data.directoryId = directory.id;
    var res = await directory.resource.applicationColl.insert(data);
    if (res != null) {
      notify('insert', [res]);
      return res;
    }
    return null;
  }

  @override
  Future<bool> loadContent({bool reload = false}) async {
    await loadWorks(reload: reload);
    return true;
  }

  @override
  List<OperateModel> operates({int? mode = 0}) {
    final List<OperateModel> operates = [
      OperateModel.fromJson(DirectoryOperates.refresh.toJson()),
      ...super.operates(mode: mode),
    ];

    if (mode == 2 && directory.target.hasRelationAuth()) {
      operates.add(OperateModel.fromJson(DirectoryOperates.newModule.toJson()));
      operates.add(OperateModel.fromJson(DirectoryOperates.newWork.toJson()));
      if (directory.target.user?.copyFiles.isNotEmpty ?? false) {
        operates.add(OperateModel.fromJson(FileOperates.parse.toJson()));
      }
    }
    var tmp = [];
    tmp.add(OperateModel.fromJson(FileOperates.copy.toJson()));
    tmp.add(OperateModel.fromJson(FileOperates.download.toJson()));
    return operates
        .where(
          (a) => !tmp.contains(a),
        )
        .toList();
  }

  void loadChildren(List<XApplication>? applications) {
    if (applications != null && applications.isNotEmpty) {
      applications.where((i) => i.parentId == id).forEach((i) {
        children.add(Application(i, directory,
            parent: this, applications: applications));
      });
    }
  }

  List<XApplication> getChildren(IApplication application) {
    List<XApplication> applications = [application.metadata];
    for (var child in application.children) {
      applications.add(child.metadata);
      applications.addAll(getChildren(child));
    }
    return applications;
  }

  @override
  Future<bool> receiveMessage(String operate, XApplication data) async {
    if (data.parentId == id) {
      switch (operate) {
        case 'insert':
          coll.cache.add(data);
          children.add(Application(data, directory, parent: this));
          break;
        case 'replace':
          {
            final index = coll.cache.indexWhere((a) => a.id == data.id);
            coll.cache[index] = data;
            final childIndex = children.indexWhere((a) => a.id == data.id);
            (children[childIndex] as Application).setMetadata(data);
          }
          break;
        case 'delete':
          await coll.removeCache(data.id);
          children = children.where((a) => a.id != data.id).toList();
          break;
      }
      structCallback();
      return true;
    } else {
      for (var child in children) {
        await child.receiveMessage(operate, data);
      }
    }
    return false;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
