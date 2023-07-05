import 'package:flutter/material.dart';
import 'package:flutter/src/material/popup_menu.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/thing/directory.dart';
import 'package:orginone/dart/core/work/index.dart';
import 'package:orginone/main.dart';

import 'file_info.dart';

abstract class IApplication implements IFileInfo<XApplication> {

  //上级模块
  IApplication? parent;

  //下级模块
  late List<IApplication> children;

  //流程定义
  late List<IWork> works;

  //更新应用
  Future<bool> update(ApplicationModel data);

  //加载办事
  Future<List<IWork>> loadWorks({bool reload = false});

  //新建办事
  Future<IWork?> createWork(WorkDefineModel data);
}

class Application extends FileInfo<XApplication> implements IApplication {
  Application(super.metadata, super.directory,
      [this.parent, List<XApplication>? applications]) {
    children = [];
    works = [];
    loadChildren(applications);
  }

  @override
  late List<IApplication> children;

  @override
  IApplication? parent;

  @override
  late List<IWork> works;

  @override
  Future<bool> copy(IDirectory destination) async {
    if (destination.id != directory.id) {
      var data = ApplicationModel.fromJson(metadata.toJson());
      data.directoryId = directory.id!;
      var res = await destination.createApplication(data);
      return res != null;
    }
    return false;
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
  Future<bool> delete() async {
    var res = await kernel.deleteApplication(IdReq(id: id!));
    if (res.success) {
      directory.applications.removeWhere((i) => i.id == id);
    }
    return res.success;
  }

  @override
  Future<List<IWork>> loadWorks({bool reload = false}) async {
    if (works.isEmpty || reload) {
      var res = await kernel.queryWorkDefine(IdReq(id: id!));
      if (res.success && res.data != null) {
        works = res.data!.result?.map((a) => Work(a, this)).toList() ?? [];
      }
    }
    return works;
  }

  @override
  Future<bool> move(IDirectory destination) async {
    if (destination.id != directory.id &&
        destination.metadata.belongId == directory.metadata.belongId) {
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
  Future<bool> rename(String name) async {
    var data = ApplicationModel.fromJson(metadata.toJson());
    data.name = name;
    return await update(data);
  }

  @override
  Future<bool> update(ApplicationModel data) async {
    data.id = id!;
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

  @override
  // TODO: implement popupMenuItem
  List<PopupMenuItem> get popupMenuItem{
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
  List<IFileInfo<XEntity>> content(int mode) {
    final List<IFileInfo<XEntity>> fileList = [...children, ...works];
    fileList.sort((a, b) => DateTime.parse(a.metadata.updateTime??"").compareTo(DateTime.parse(b.metadata.updateTime??"")));
    return fileList.reversed.toList();
  }

  @override
  // TODO: implement locationKey
  String get locationKey => key;
}
