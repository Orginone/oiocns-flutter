import 'package:orginone/dart/base/common/commands.dart';

import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/public/collection.dart';
import 'package:orginone/dart/core/public/entity.dart';
import 'package:orginone/dart/core/public/operates.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/thing/directory.dart';

/// 默认文件接口
abstract class IFile extends IFileInfo<XEntity> {}

abstract class IFileInfo<T extends XEntity> extends IEntity<T> {
  /// 缓存
  late XCache cache;

  /// 空间ID
  late String spaceId;
  //归属ID
  @override
  late String belongId;
  //是否为继承的类别
  late bool isInherited;

  /// 是否允许设计
  late bool canDesign;

  /// 是否为容器
  late bool isContainer;

  ///目录
  late IDirectory directory;

  /// 上级
  late IFile superior;

  /// 路径Key
  late String locationKey;

  /// 撤回已删除
  Future<bool> restore();

  /// 删除文件系统项
  Future<bool> delete({bool? notity});

  /// 彻底删除文件系统项
  Future<bool> hardDelete({bool? notity});
  //重命名
  Future<bool> rename(String name);

  //拷贝文件系统项（目录）
  Future<bool> copy(IDirectory destination);

  //移动文件系统项（目录）
  Future<bool> move(IDirectory destination);

  //加载文件内容
  Future<bool> loadContent({bool reload = false});

  ///目录下的内容
  List<IFile> content({bool? args});

  /// 缓存用户数据
  Future<bool> cacheUserData({bool? notify});
}

/// 文件类抽象实现
abstract class FileInfo<T extends XEntity> extends Entity<T>
    implements IFileInfo<T> {
  FileInfo(
    T metadata,
    this.directory,
  ) : super(metadata, metadata.typeName != null ? [metadata.typeName!] : []) {
    cache = XCache(fullId: '${this.spaceId}_${metadata.id}');
    Future.delayed(Duration(milliseconds: id == userId ? 100 : 0), () async {
      await loadUserData();
    });
  }

  @override
  late XCache cache;
  @override
  IDirectory directory;
  @override
  bool canDesign = false;
  @override
  bool get isContainer {
    return false;
  }

  @override
  bool get isInherited => directory.isInherited;

  ITarget get target {
    if (directory.typeName.contains('目录')) {
      return directory.target;
    } else {
      return directory as ITarget;
    }
  }

  @override
  String get belongId => target.belongId;

  @override
  String get spaceId => target.spaceId;

  @override
  String get locationKey => directory.key;

  String get cachePath => '$cacheFlag.${cache.fullId}';
  abstract String cacheFlag;
  @override
  IFile get superior {
    return this.directory as IFile;
  }

  @override
  Future<bool> delete({bool? notity});

  @override
  Future<bool> rename(String name) async {
    await Future.delayed(Duration.zero);
    return true;
  }

  @override
  Future<bool> copy(IDirectory destination) async {
    await Future.delayed(Duration.zero);
    return true;
  }

  @override
  Future<bool> move(IDirectory destination) async {
    await Future.delayed(Duration.zero);
    return true;
  }

  @override
  Future<bool> restore() async {
    await Future.delayed(Duration.zero);
    return true;
  }

  @override
  Future<bool> hardDelete({bool? notity}) async {
    await Future.delayed(Duration.zero);
    return true;
  }

  Future<void> loadUserData() async {
    final data =
        await target.user?.cacheObj.get<XCache>(cachePath, XCache.fromJson);
    if (data?.fullId == cache.fullId) {
      cache = data!;
    }
    target.user?.cacheObj.subscribe(cachePath, (XCache data) {
      if (data.fullId == cache.fullId) {
        cache = data;
        target.user?.cacheObj.setValue(cachePath, data);
        directory.changCallback();
        command.emitterFlag(cacheFlag);
      }
    }, data?.fullId);
  }

  @override
  Future<bool> cacheUserData({bool? notify = true}) async {
    final success = await target.user?.cacheObj.set(cachePath, cache);
    if (success! && notify!) {
      await target.user?.cacheObj
          .notity(cachePath, cache, onlyTarget: true, ignoreSelf: false);
    }
    return success;
  }

  @override
  Future<bool> loadContent({bool reload = false}) async {
    await Future.delayed(
        reload ? const Duration(milliseconds: 10) : Duration.zero);
    return true;
  }

  @override
  List<IFile> content({bool? args}) {
    return [];
  }

  @override
  List<OperateModel> operates({int? mode = 0}) {
    final operates = super.operates(mode: mode);
    if (mode! % 2 == 0) {
      if (target.space!.hasRelationAuth()) {
        operates.insert(0, OperateModel.fromJson(FileOperates.copy.toJson()));
      }
      if (target.hasRelationAuth()) {
        operates.insertAll(0, [
          OperateModel.fromJson(FileOperates.move.toJson()),
          OperateModel.fromJson(FileOperates.rename.toJson()),
          OperateModel.fromJson(FileOperates.download.toJson()),
          OperateModel.fromJson(EntityOperates.update.toJson()),
          OperateModel.fromJson(EntityOperates.delete.toJson()),
        ]);
      }
    }
    return operates;
  }
}

abstract class IStandardFileInfo<T extends XStandard> implements IFileInfo<T> {
  /// 归属组织key
  late String spaceKey;

  /// 设置当前元数据
  /// TODO: 继承关系 方法重名报错
  /// 'Entity.setMetadata' ('void Function(XTransfer)') isn't a valid concrete implementation of 'IStandardFileInfo.setMetadata'
  void setMetadataA(XStandard metadata);
  Future<bool> notify(String operate, List<XEntity> data);
  Future<bool> update(T data);

  /// 接收通知
  bool receive(String operate, dynamic data);
}

abstract class IStandard extends IStandardFileInfo<XStandard> {}

abstract class StandardFileInfo<T extends XStandard> extends FileInfo<T>
    implements IStandardFileInfo<T> {
  XCollection<T> coll;

  StandardFileInfo(T metadata, IDirectory directory, this.coll)
      : super(metadata, directory);
  @override
  String get spaceKey {
    return directory.target.space?.directory.key ?? '';
  }

  @override
  Future<bool> copy(IDirectory destination);

  @override
  Future<bool> move(IDirectory destination);

  @override
  T get metadata => this.metadata;

  bool allowCopy(IDirectory destination) {
    return target.belongId != destination.target.belongId;
  }

  bool allowMove(IDirectory destination) {
    return destination.id != directory.id &&
        destination.target.belongId == target.belongId;
  }

  @override
  Future<bool> update(T data) async {
    final res = await coll.replace({
      ...metadata.toJson(),
      ...data.toJson(),
      'directoryId': metadata.directoryId,
      'typeName': metadata.typeName,
    } as T);
    if (res != null) {
      await notify('replace', [res]);
      return true;
    }
    return false;
  }

  @override
  Future<bool> delete({bool? notity}) async {
    final data = await coll.delete(metadata);
    if (data) {
      await notify('delete', [metadata]);
    }
    return false;
  }

  @override
  Future<bool> rename(String name) async {
    return await update({
      'name': name,
      ...this.metadata.toJson(),
    } as T);
  }

  Future<bool> copyTo(String directoryId, {XCollection<T>? coll}) async {
    final targetColl = coll ?? this.coll;
    final data = await targetColl.replace({
      ...metadata.toJson(),
      'directoryId': directoryId,
    } as T);
    if (data != null) {
      return await targetColl.notity({
        'data': [data.toJson()],
        'operate': 'insert',
      });
    }
    return false;
  }

  Future<bool> moveTo(String directoryId, {XCollection<T>? coll}) async {
    final targetColl = coll ?? this.coll;
    final data = await targetColl.replace({
      ...metadata.toJson(),
      'directoryId': directoryId,
    } as T);
    if (data != null) {
      await notify('delete', [metadata]);
      return await targetColl.notity({
        'data': [data.toJson()],
        'operate': 'insert',
      });
    }
    return false;
  }

  @override
  Future<bool> notify(String operate, List<XEntity> data) async {
    return await coll.notity(
        {'data': data.map((d) => d.toJson()).toList(), 'operate': operate});
  }

  @override
  bool receive(String operate, dynamic data) {
    switch (operate) {
      case 'delete':
      case 'replace':
        if (operate == 'delete') {
          data.isDeleted = true;

          setMetadata(data);
        } else {
          setMetadata(data);
          loadContent(reload: true);
        }
    }
    return true;
  }
}
