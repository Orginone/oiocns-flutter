import 'dart:async';

import 'package:get/get.dart';
import 'package:orginone/dart/base/common/commands.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/public/consts.dart';
import 'package:orginone/dart/core/public/operates.dart';
import 'package:orginone/dart/core/thing/directory.dart';
import 'package:orginone/dart/core/thing/fileinfo.dart';
import 'package:orginone/dart/core/work/index.dart';
import 'package:orginone/main_base.dart';

abstract class IApplication implements IStandardFileInfo<XApplication> {
  ///上级模块
  IApplication? parent;

  ///下级模块
  late final List<IApplication> children;

  ///流程定义
  late final List<IWork> works;

  /// 结构变更
  void structCallback();

  ///根据id查找办事
  Future<IWork?> findWork(String id);

  ///加载办事
  Future<List<IWork>> loadWorks({bool reload = false});

  ///新建办事
  Future<IWork?> createWork(WorkDefineModel data);

  ///新建模块
  Future<XApplication?> createModule(XApplication data);

  // ///接收模块变更消息
  // Future<bool> receiveMessage(String operate, XApplication data);
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
  List<IFile> content({bool? args}) {
    final List<IFile> fileList = [
      ...children.map((e) => e as IFile),
      ...works.map((e) => e as IFile)
    ];
    fileList.sort((a, b) => DateTime.parse(a.metadata.updateTime ?? "")
        .compareTo(DateTime.parse(b.metadata.updateTime ?? "")));
    return fileList.reversed.toList();
  }

  @override
  structCallback() {
    command.emitter('executor', 'refresh', [this]);
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
  Future<bool> hardDelete({bool? notity}) async {
    if (await directory.resource.applicationColl
        .removeMany(getChildren(this))) {
      notify('remove', [metadata]);
    }
    return false;
  }

  // @override
  // Future<bool> delete({bool? notity}) async {
  //   final success = await directory.resource.applicationColl.deleteMany(
  //     getChildren(this),
  //   );
  //   if (success) {
  //     return await super.delete();
  //   }
  //   return success;
  // }
  @override
  Future<IWork?> findWork(String id) async {
    await loadWorks();
    var find = works.where((i) => i.id == id).toList();
    if (find.isNotEmpty) {
      return find.first;
    }
    for (var item in children) {
      var find = await item.findWork(id);
      if (find != null) {
        return find;
      }
    }
    return null;
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
  bool receive(String operate, dynamic data) {
    var d = data as XApplication;
    if (d.id == id) {
      coll.removeCache((i) => i.id != d.id);
      super.receive(operate, d);
      coll.cache.add(metadata);
      if (parent != null) {
        parent!.changCallback();
        return true;
      }
      directory.changCallback();

      return true;
    } else if (d.parentId == id) {
      if (operate.startsWith('work')) {
        workReceive(operate, d);
      } else {
        switch (operate) {
          case 'insert':
            coll.cache.add(d);
            children.add(Application(d, directory, parent: this));
            break;
          case 'replace':
            {
              final index = coll.cache.indexWhere((a) => a.id == d.id);
              coll.cache[index] = d;
              final childIndex = children.indexWhere((a) => a.id == d.id);
              (children[childIndex] as Application).setMetadata(data);
            }
            break;
          case 'remove':
            coll.removeCache((i) => i.id != d.id);
            children = children.where((a) => a.id != d.id).toList();
            break;
        }
      }

      structCallback();
      return true;
    } else {
      for (var child in children) {
        child.receive(operate, data);
        return true;
      }
    }
    return false;
  }

  bool workReceive(String operate, dynamic data) {
    switch (operate) {
      case 'workInsert':
        if (works.every((i) => i.id != data.id)) {
          var work = Work(data as XWorkDefine, this);
          works.add(work);
        }
        break;
      case 'workRemove':
        works = works.where((i) => i.id != data.id).toList();
        break;
      case 'workReplace':
        works.firstWhereOrNull((i) => i.id == data.id)?.receive(operate, data);
        break;
    }
    return true;
  }

  @override
  set belongId(String belongId) {
    // TODO: implement belongId
  }

  @override
  set cacheFlag(String cacheFlag) {
    // TODO: implement cacheFlag
  }

  @override
  set isContainer(bool isContainer) {
    // TODO: implement isContainer
  }

  @override
  set isInherited(bool isInherited) {
    // TODO: implement isInherited
  }

  @override
  set locationKey(String locationKey) {
    // TODO: implement locationKey
  }

  @override
  void setMetadataA(XStandard metadata) {
    // TODO: implement setMetadataA
  }

  @override
  set spaceId(String spaceId) {
    // TODO: implement spaceId
  }

  @override
  set spaceKey(String spaceKey) {
    // TODO: implement spaceKey
  }

  @override
  set superior(IFile superior) {
    // TODO: implement superior
  }
}
