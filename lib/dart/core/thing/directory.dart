import 'dart:io';

import 'package:orginone/dart/base/common/commands.dart';
import 'package:orginone/dart/base/common/emitter.dart';
import 'package:orginone/dart/base/common/format.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/public/operates.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/target/outTeam/storage.dart';
import 'package:orginone/dart/core/thing/fileinfo.dart';
import 'package:orginone/dart/core/thing/resource.dart';
import 'package:orginone/dart/core/thing/standard/index.dart';
import 'package:orginone/dart/core/thing/standard/page.dart';
import 'package:orginone/dart/core/thing/standard/index_standart.dart';
import 'package:orginone/dart/core/thing/systemfile.dart';
import 'package:orginone/utils/index.dart';

/// 可为空的进度回调
typedef OnProgress = void Function(double p);

/// 目录接口类
abstract class IDirectory implements IStandardFileInfo<XDirectory> {
  /// 目录下标准类
  late StandardFiles standard;

  /// 当前加载目录的用户
  late ITarget target;

  /// 资源类
  late DataResource resource;

  /// 上级目录
  IDirectory? parent;

  /// 下级文件系统项数组
  late List<IDirectory> children;

  /// 上传任务列表
  late List<TaskModel> taskList;

  /// 任务发射器
  late Emitter taskEmitter;

  /// 目录结构变更
  void structCallback({bool? reload});

  /// 目录下的内容

  @override
  List<IFile> content({bool? args});

  /// 创建子目录
  Future<XDirectory?> create(XDirectory data);

  /// 目录下的文件
  late List<ISysFileInfo> files;

  /// 加载模板配置
  Future<List<IPageTemplate>> loadAllTemplate({bool? reload});

  /// 加载文件
  Future<List<ISysFileInfo>> loadFiles({bool? reload});

  /// 上传文件
  Future<ISysFileInfo?> createFile(File file, {OnProgress? p});

  /// 加载全部应用
  Future<List<IApplication>> loadAllApplication();

  /// 加载目录资源
  Future<void> loadDirectoryResource({bool? reload});

  /// 加载目录资源
  Future<bool> notifyReloadFiles();
}

///MirrorDirectory作为 Directory影子类  用来初始化避免直接在Directory 创建Directory 造成递归
class MirrorDirectory implements IDirectory {
  MirrorDirectory();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

///目录实现类
class Directory extends StandardFileInfo<XDirectory> implements IDirectory {
  Directory(
    this.metadata,
    this.target, {
    this.parent,
    List<XDirectory>? directorys,
  }) : super(
            XDirectory.fromJson(
                {...metadata.toJson(), 'typeName': metadata.typeName ?? '目录'}),
            parent ?? MirrorDirectory(),
            target.resource.directoryColl) {
    taskEmitter = Emitter();
    standard = StandardFiles(this);
  }
  @override
  late StandardFiles standard;

  @override
  late Emitter taskEmitter;
  @override
  IDirectory? parent;
  @override
  final XDirectory metadata;
  @override
  final ITarget target;
  @override
  List<TaskModel> taskList = [];
  @override
  List<ISysFileInfo> files = [];

  @override
  bool get isContainer {
    return true;
  }

  @override
  String get cacheFlag => 'directorys';
  @override
  IFile get superior {
    return parent == null
        ? (target.superior.directory as IFile)
        : parent as IFile;
  }

  @override
  List<String> get groupTags {
    if (parent != null) {
      return super.groupTags;
    } else {
      return [target.typeName];
    }
  }

  @override
  String get spaceKey {
    return target.space?.directory.key ?? '';
  }

  @override
  List<IDirectory> get children {
    return standard.directorys;
  }

  @override
  String get id {
    if (parent == null) {
      return target.id;
    }
    return super.id;
  }

  @override
  bool get isInherited {
    return target.isInherited;
  }

  @override
  String get locationKey {
    return key;
  }

  @override
  DataResource get resource {
    return target.resource;
  }

  @override
  structCallback({bool? reload}) {
    if (reload != null && reload) {
      command.emitter('executor', 'reload', [this]);
    } else {
      command.emitter('executor', 'refresh', [this]);
    }
    changCallback();
  }

  @override
  List<IFile> content({bool? args}) {
    args ??= true;
    List<IFile> cnt = [];
    cnt.addAll(children.map((e) => e as IFile).toList());

    if (target.session.isMyChat || target.hasRelationAuth()) {
      cnt.addAll(files.map((e) => e as IFile).toList());
      cnt.addAll(standard.forms.map((e) => e as IFile));
      cnt.addAll(standard.applications.map((e) => e as IFile));
      cnt.addAll(standard.propertys.map((e) => e as IFile));
      cnt.addAll(standard.specieses.map((e) => e as IFile));
      cnt.addAll(standard.transfers.map((e) => e as IFile));
      cnt.addAll(standard.templates.map((e) => e as IFile));
      if (parent != null && args == true) {
        for (var item in target.content()) {
          var target = item;
          if (item is ITarget || item is IDirectory || item is IStorage) {
            if (item is IDirectory) {
              cnt.add(target.directory as IFile);
            }
            if (item is IStorage) {
              cnt.add(target.directory as IFile);
            }
          }
        }
      }
    } // return cnt.sort((a, b) => (a.metadata.updateTime < b.metadata.updateTime ? 1 : -1));
    cnt.sort((a, b) {
      return DateTime.parse(a.metadata.updateTime ?? "")
          .compareTo(DateTime.parse(b.metadata.updateTime ?? ""));
    });
    return cnt;
  }

  @override
  Future<bool> loadContent({bool reload = false}) async {
    LogUtil.d('directory-loadContent');
    await loadFiles(reload: reload);
    await standard.loadStandardFiles(reload: reload);
    if (reload) {
      // if (typeName == '成员目录') {
      //   await target.loadContent(reload: reload);
      // } else {
      await loadDirectoryResource(reload: reload);
      // }
    }
    return true;
  }

  @override
  Future<bool> copy(IDirectory destination) async {
    if (allowCopy(destination)) {
      metadata.directoryId = destination.id;
      final data = await destination.resource.directoryColl.replace(metadata);
      if (data != null) {
        await operateDirectoryResource(
          this,
          destination.resource,
          'replaceMany',
          move: false,
        );
        await destination.notify('refresh', [data]);
      }
    }
    return false;
  }

  @override
  Future<bool> move(IDirectory destination) async {
    if (parent != null && allowMove(destination)) {
      metadata.directoryId = destination.id;
      final data = await destination.resource.directoryColl.replace(metadata);
      if (data != null) {
        await operateDirectoryResource(
          this,
          destination.resource,
          'replaceMany',
          move: true,
        );
        await notify('refresh', [metadata]);
        await destination.notify('refresh', [data]);
      }
    }
    return false;
  }

  @override
  Future<bool> delete({bool? notity}) async {
    if (parent != null) {
      await resource.directoryColl.delete(metadata);
      await notify('delete', [metadata]);
    }
    return false;
  }

  @override
  Future<bool> hardDelete({bool? notity}) async {
    if (parent != null) {
      await resource.directoryColl.remove(metadata);
      await operateDirectoryResource(this, resource, 'removeMany');
      await notify('reload', [metadata]);
    }
    return false;
  }

  @override
  Future<XDirectory?> create(XDirectory data) async {
    metadata.directoryId = id;
    metadata.typeName = '目录';
    final res = await resource.directoryColl.insert(metadata);
    if (res != null) {
      await notify('insert', [res]);
      return res;
    }
    return null;
  }

  @override
  Future<List<ISysFileInfo>> loadFiles({bool? reload}) async {
    reload ?? false;
    if (files.isEmpty || reload == true) {
      final res = await resource.bucketOpreate<List<FileItemModel>>(
          BucketOpreateModel(
            key: encodeKey(id.replaceAll('_', '')), //有的地方id拼接了_注意去除
            operate: BucketOpreates.list,
          ), (data) {
        return FileItemModel.fromList(data['data'] ?? []);
      });
      if (res.success && res.data!.isNotEmpty) {
        files = res.data!
            .where((i) => !i.isDirectory)
            .map((item) => SysFileInfo(item, this))
            .toList();
      }
    }
    return files;
  }

  @override
  Future<ISysFileInfo?> createFile(File file, {OnProgress? p}) async {
    // while (taskList.where((i) => i.finished < i.size).length > 2) {
    //   sleep(const Duration(milliseconds: 1000));
    // }

    p?.call(0);
    String fileName = file.path.split("/").last;
    final task = TaskModel(
      name: fileName,
      finished: 0,
      size: file.lengthSync(),
      createTime: DateTime.now(),
    );

    taskList.add(task);

    final data = await resource.fileUpdate(
      file,
      '$id/$fileName',
      progress: (progress) {
        task.finished = progress.toInt();
        p?.call(progress);
        taskEmitter.changCallback();
      },
    );
    if (data != null) {
      final fileInfo = SysFileInfo(data, this);
      files.add(fileInfo);
      return fileInfo;
    }

    return null;
  }

  @override
  Future<List<IApplication>> loadAllApplication() async {
    final List<IApplication> applications = [...standard.applications];

    for (var item in children) {
      applications.addAll(await item.loadAllApplication());
    }

    return applications;
  }

  @override
  Future<List<IPageTemplate>> loadAllTemplate({bool? reload}) async {
    List<IPageTemplate> templates = [...standard.templates];
    for (var item in children) {
      templates.addAll((await item.loadAllTemplate(reload: reload)));
    }
    return templates;
  }

  @override
  List<OperateModel> operates({int? mode = 0}) {
    final List<OperateModel> operates = [];
    if (typeName == '成员目录') {
      if (target.hasRelationAuth()) {
        if (target.user?.copyFiles.isNotEmpty ?? false) {
          operates.add(OperateModel.fromJson(FileOperates.parse.toJson()));
        }
        operates.add(OperateModel.fromJson(TeamOperates.pull.toJson()));
        operates.add(
            OperateModel.fromJson(MemberOperates.settingIdentity.toJson()));

        if (target.hasAuthoritys(['superAuth'])) {
          operates.insert(
              0, OperateModel.fromJson(MemberOperates.settingAuth.toJson()));
          if (target.hasAuthoritys(['stations'])) {
            operates.insert(0,
                OperateModel.fromJson(MemberOperates.settingStation.toJson()));
          }
        }
      }
    } else {
      operates.add(OperateModel.fromJson(DirectoryOperates.newFile.toJson()));
      operates.add(OperateModel.fromJson(DirectoryOperates.taskList.toJson()));
      operates.add(OperateModel.fromJson(DirectoryOperates.refresh.toJson()));
      operates.add(OperateModel.fromJson(
          DirectoryOperates.openFolderWithEditor.toJson()));

      if (mode == 2 && target.hasRelationAuth()) {
        operates.add(OperateModel.fromJson(DirectoryNew().toJson()));
        operates.add(OperateModel.fromJson(NewWarehouse().toJson()));

        if (target.user?.copyFiles.isNotEmpty ?? false) {
          operates.add(OperateModel.fromJson(FileOperates.parse.toJson()));
        }
      }
      if (parent != null) {
        operates.addAll(super.operates(mode: mode));
      } else if (mode! % 2 == 0) {
        operates.addAll(target.operates());
      } else {
        operates.addAll(super.operates(mode: 1));
      }
    }
    return operates;
  }

  @override
  Future<void> loadDirectoryResource({bool? reload = false}) async {
    if (parent == null || reload == true) {
      await resource.preLoad(reload: reload!);
    }
    await standard.loadApplications();
    await standard.loadDirectorys();
    await standard.loadTemplates();
  }

  ///对目录下所有资源进行操作
  //action只支持 'replaceMany' | 'deleteMany'
  Future<void> operateDirectoryResource(
    IDirectory directory,
    DataResource resource,
    String action, //'replaceMany' | 'removeMany',
    {
    bool? move = false,
  }) async {
    if (action == 'removeMany') {
      this.resource.deleteDirectory(directory.id);
    }
    for (var child in directory.children) {
      await operateDirectoryResource(child, resource, action, move: move);
    }
    await directory.standard.operateStandradFile(resource, action, move);
  }

  @override
  bool receive(String operate, dynamic data) {
    var d = data as XStandard;
    coll.removeCache((i) => i.id != d.id);
    super.receive(operate, d);
    coll.cache.add(metadata);
    return true;
  }

  @override
  Future<bool> notifyReloadFiles() {
    metadata.directoryId = id;
    return coll.notity(
      {
        'data': metadata,
        'operate': 'reloadFiles',
      },
      ignoreSelf: true,
    );
  }

  // @override
  // Future<XForm?> createForm(XForm data) async {
  //   data.directoryId = id;
  //   final res = await resource.formColl.insert(data);

  //   if (res != null) {
  //     await resource.formColl.notity({
  //       data: [res],
  //       'operate': 'insert'
  //     });
  //     return res;
  //   }
  //   return null;
  // }

  // @override
  // Future<XSpecies?> createSpecies(XSpecies data) async {
  //   data.directoryId = id;
  //   final res = await resource.speciesColl.insert(data);
  //   if (res != null) {
  //     await resource.speciesColl.notity({
  //       data: [res],
  //       'operate': 'insert'
  //     });
  //     return res;
  //   }
  //   return null;
  // }

  // @override
  // Future<XProperty?> createProperty(XProperty data) async {
  //   data.directoryId = id;
  //   final res = await resource.propertyColl.insert(data);
  //   if (res != null) {
  //     await resource.propertyColl.notity({
  //       data: [res],
  //       'operate': 'insert'
  //     });
  //     return res;
  //   }
  //   return null;
  // }

  // @override
  // Future<XApplication?> createApplication(XApplication data) async {
  //   data.directoryId = id;

  //   final res = await resource.applicationColl.insert(data);
  //   if (res != null) {
  //     await resource.applicationColl.notity({
  //       data: [res],
  //       'operate': 'insert'
  //     });
  //     return res;
  //   }
  //   return null;
  // }

  // @override
  // Future<Transfer?> createTransfer(XTransfer data) async {
  //   data.directoryId = id;
  //   data.envs = [];
  //   data.nodes = [];
  //   data.edges = [];

  //   final res = await resource.transferColl.insert(data);
  //   if (res != null) {
  //     final link = Transfer(res, this);
  //     standard.transfers.add(link);
  //     await resource.transferColl.notity({
  //       data: [res],
  //       'operate': 'insert'
  //     });
  //     return link;
  //   }
  //   return null;
  // }

  // @override
  // Future<List<ITransfer>> loadAllTransfer({bool? reload = false}) async {
  //   final List<ITransfer> links = standard.transfers;

  //   for (var subDirectory in children) {
  //     links.addAll(await subDirectory.loadAllTransfer(reload: reload));
  //   }

  //   return links;
  // }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
