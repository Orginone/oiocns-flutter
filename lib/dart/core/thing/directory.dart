import 'dart:io';

import 'package:orginone/dart/base/common/commands.dart';
import 'package:orginone/dart/base/common/emitter.dart';
import 'package:orginone/dart/base/common/format.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/public/operates.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/thing/fileinfo.dart';
import 'package:orginone/dart/core/thing/member.dart';
import 'package:orginone/dart/core/thing/operate.dart';
import 'package:orginone/dart/core/thing/resource.dart';
import 'package:orginone/dart/core/thing/standard/index.dart';
import 'package:orginone/dart/core/thing/standard/transfer.dart';

/// 可为空的进度回调
typedef OnProgress = void Function(double p);

/// 目录接口类
abstract class IDirectory implements IStandardFileInfo<XDirectory> {
  /// 目录操作类
  late IDirectoryOperate operater;

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
  void structCallback();

  /// 目录下的内容
  @override
  List<IFileInfo<XEntity>> content({int? mode});

  /// 创建子目录
  Future<XDirectory?> create(XDirectory data);

  /// 目录下的文件
  late List<ISysFileInfo> files;

  /// 目录下的表单
  late List<IForm> forms;

  /// 目录下的分类
  late List<ISpecies> specieses;

  /// 目录下的属性
  late List<IProperty> propertys;

  /// 目录下的应用
  late List<IApplication> applications;

  /// 目录下的链接
  late List<ITransfer> transfers;

  /// 新建迁移配置
  Future<ITransfer?> createTransfer(XTransfer data);

  /// 加载迁移配置
  Future<List<ITransfer>> loadAllTransfer({bool? reload});

  /// 加载文件
  Future<List<ISysFileInfo>> loadFiles({bool reload});

  /// 上传文件
  Future<ISysFileInfo?> createFile(File file, {OnProgress? p});

  /// 新建表单
  Future<XForm?> createForm(XForm data);

  /// 新建分类
  Future<XSpecies?> createSpecies(XSpecies data);

  /// 新建属性
  Future<XProperty?> createProperty(XProperty data);

  /// 新建应用
  Future<XApplication?> createApplication(XApplication data);

  /// 加载全部应用
  Future<List<IApplication>> loadAllApplication({bool? reload});

  /// 加载目录资源
  Future<void> loadDirectoryResource({bool? reload});
}

///MirrorDirectory作为 Directory影子类  用来初始化避免直接在Directory 创建Directory 造成递归
class MirrorDirectory implements IDirectory {
  MirrorDirectory();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

///目录实现类
class Directory extends StandardFileInfo<XDirectory> implements IDirectory {
  Directory(this.metadata, this.target,
      {this.parent, List<XDirectory>? directorys})
      : super(
            XDirectory.fromJson(
                {...metadata.toJson(), 'typeName': metadata.typeName ?? '目录'}),
            parent ?? MirrorDirectory(),
            target.resource.directoryColl) {
    isContainer = true;
    taskEmitter = Emitter();
    operater = DirectoryOperate(this, target.resource);
  }
  // StandardFiles standard;
  @override
  late IDirectoryOperate operater;
  @override
  late Emitter taskEmitter;
  @override
  IDirectory? parent;
  @override
  final XDirectory metadata;
  @override
  final ITarget target;
  @override
  late List<TaskModel> taskList;
  @override
  late List<ISysFileInfo> files;

  List<String> formTypes = ['表单', '报表', '事项配置', '实体配置'];

  @override
  String get cacheFlag => 'directorys';

  @override
  List<IForm> get forms => operater.getContent(formTypes);
  @override
  List<ITransfer> get transfers => operater.getContent<ITransfer>(['迁移配置']);
  @override
  List<ISpecies> get specieses => operater.getContent<ISpecies>(['分类', '字典']);
  @override
  List<IProperty> get propertys => operater.getContent<IProperty>(['属性']);
  @override
  List<IApplication> get applications =>
      operater.getContent<IApplication>(['应用']);
  @override
  List<IDirectory> get children => operater.getContent<IDirectory>(['目录']);
  @override
  String get id {
    if (parent != null) {
      return target.id;
    }
    return super.id;
  }

  @override
  bool get isInherited {
    return metadata.belongId != target.space?.id ?? false;
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
  structCallback() {
    command.emitter('-', 'refresh', [this]);
  }

  @override
  List<IFileInfo<XEntity>> content({int? mode}) {
    List<IFileInfo<XEntity>> cnt = [
      ...children,
    ];
    if (typeName == '成员目录') {
      cnt.addAll(target.members.map((i) => Member(i, this)).toList());
    } else {
      cnt.addAll(forms);
      cnt.addAll(applications);
      cnt.addAll(files);
      cnt.addAll(transfers);
      if (mode != 1) {
        cnt.addAll(propertys);
        cnt.addAll(specieses);
        if (parent != null) {
          cnt.insert(0, target.memberDirectory);
          cnt.addAll(target.content(mode: mode));
        }
      }
      cnt.sort((a, b) {
        return DateTime.parse(a.metadata.updateTime ?? "")
            .compareTo(DateTime.parse(b.metadata.updateTime ?? ""));
      });
    }

    return cnt;
  }

  @override
  Future<bool> loadContent({bool reload = false}) async {
    await loadFiles(reload: reload);
    if (reload) {
      if (typeName == '成员目录') {
        await target.loadContent(reload: reload);
      } else {
        await loadDirectoryResource(reload: reload);
      }
    }
    return false;
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
  Future<bool> delete() async {
    if (parent != null) {
      await resource.directoryColl.delete(metadata);
      await operateDirectoryResource(this, resource, 'deleteMany');
      await notify('refresh', [metadata]);
    }
    return false;
  }

  @override
  Future<XDirectory?> create(XDirectory data) async {
    metadata.directoryId = id;
    final res = await resource.directoryColl.insert(metadata);
    if (res != null) {
      await notify('insert', [res]);
      return res;
    }
    return null;
  }

  @override
  Future<List<ISysFileInfo>> loadFiles({bool reload = false}) async {
    if (files.isEmpty || reload) {
      final res =
          await resource.bucketOpreate<List<FileItemModel>>(BucketOpreateModel(
        key: encodeKey(id),
        operate: BucketOpreates.list,
      ));
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
    while (taskList.where((i) => i.finished < i.size).length > 2) {
      sleep(const Duration(milliseconds: 1000));
    }

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
      file.readAsBytesSync(),
      '$id/$fileName',
      (pn) {
        task.finished = pn.toInt();
        p?.call(pn);
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
  Future<XForm?> createForm(XForm data) async {
    data.directoryId = id;
    final res = await resource.formColl.insert(data);

    if (res != null) {
      await resource.formColl.notity({
        data: [res],
        'operate': 'insert'
      });
      return res;
    }
    return null;
  }

  @override
  Future<XSpecies?> createSpecies(XSpecies data) async {
    data.directoryId = id;
    final res = await resource.speciesColl.insert(data);
    if (res != null) {
      await resource.speciesColl.notity({
        data: [res],
        'operate': 'insert'
      });
      return res;
    }
    return null;
  }

  @override
  Future<XProperty?> createProperty(XProperty data) async {
    data.directoryId = id;
    final res = await resource.propertyColl.insert(data);
    if (res != null) {
      await resource.propertyColl.notity({
        data: [res],
        'operate': 'insert'
      });
      return res;
    }
    return null;
  }

  @override
  Future<XApplication?> createApplication(XApplication data) async {
    data.directoryId = id;

    final res = await resource.applicationColl.insert(data);
    if (res != null) {
      await resource.applicationColl.notity({
        data: [res],
        'operate': 'insert'
      });
      return res;
    }
    return null;
  }

  @override
  Future<Transfer?> createTransfer(XTransfer data) async {
    data.directoryId = id;
    data.envs = [];
    data.nodes = [];
    data.edges = [];

    final res = await resource.transferColl.insert(data);
    if (res != null) {
      final link = Transfer(res, this);
      transfers.add(link);
      await resource.transferColl.notity({
        data: [res],
        'operate': 'insert'
      });
      return link;
    }
    return null;
  }

  @override
  Future<List<IApplication>> loadAllApplication({bool? reload}) async {
    final List<IApplication> applications = this.applications;

    for (var subDirectory in children) {
      applications
          .addAll(await subDirectory.loadAllApplication(reload: reload));
    }

    return applications;
  }

  @override
  Future<List<ITransfer>> loadAllTransfer({bool? reload = false}) async {
    final List<ITransfer> links = transfers;

    for (var subDirectory in children) {
      links.addAll(await subDirectory.loadAllTransfer(reload: reload));
    }

    return links;
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
  loadDirectoryResource({bool? reload = false}) async {
    await operater.loadResource(reload: reload!);
  }

  ///对目录下所有资源进行操作
  //action只支持 'replaceMany' | 'deleteMany'
  Future<void> operateDirectoryResource(
      IDirectory directory, DataResource resource, String action,
      {bool move = false}) async {
    for (final child in directory.children) {
      await operateDirectoryResource(child, resource, action, move: move);
    }
//TODO 以下代码使用时翻译
    // await resource.directoryColl[action](
    //     directory.children.map((a) => a.metadata).toList());
    // await resource
    //     .formColl[action](directory.forms.map((a) => a.metadata).toList());
    // await resource.speciesColl[action](
    //     directory.specieses.map((a) => a.metadata).toList());
    // await resource.propertyColl[action](
    //     directory.propertys.map((a) => a.metadata).toList());

    if (action == 'deleteMany') {
      await resource.speciesItemColl.deleteMatch({
        'speciesId': {
          '_in_': directory.specieses.map((a) => a.id),
        },
      });

      await resource.applicationColl.deleteMatch({
        'directoryId': directory.id,
      });
    }

    if (action == 'replaceMany') {
      if (move) {
        final apps = directory.resource.applicationColl.cache
            .where(
              (i) => i.directoryId == directory.id,
            )
            .toList();

        await resource.applicationColl.replaceMany(apps);
      } else {
        if (this.resource.targetMetadata.belongId !=
            resource.targetMetadata.belongId) {
          final items =
              await this.directory.resource.speciesItemColl.loadSpace({
            'options': {
              'match': {
                'speciesId': {
                  '_in_': directory.specieses.map((a) => a.id),
                },
              },
            },
          });

          await resource.speciesItemColl.replaceMany(items);
        }
      }
    }
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
