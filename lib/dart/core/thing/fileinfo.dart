import 'package:flutter/material.dart';
import 'package:orginone/dart/base/common/commands.dart';
import 'package:orginone/dart/base/common/format.dart';

import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/public/collection.dart';
import 'package:orginone/dart/core/public/entity.dart';
import 'package:orginone/dart/core/public/operates.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/thing/directory.dart';

abstract class IFileInfo<T extends XEntity> extends IEntity<T> {
  /// 缓存
  late XCache cache;

  /// 空间ID
  late String spaceId;

  late bool isLoaded;

  //是否为继承的类别
  late bool isInherited;

  /// 是否为容器
  late bool isContainer;
  late IDirectory directory;

  /// 路径Key
  late String locationKey;

  List<PopupMenuItem> get popupMenuItem;

  Future<bool> delete();

  //重命名
  Future<bool> rename(String name);

  //拷贝文件系统项（目录）
  Future<bool> copy(IDirectory destination);

  //移动文件系统项（目录）
  Future<bool> move(IDirectory destination);

  //加载文件内容
  Future<bool> loadContent({bool reload = false});

  ///目录下的内容
  List<IFileInfo<XEntity>> content({int? mode});

  /// 缓存用户数据
  Future<bool> cacheUserData({bool? notify});
}

/// 文件类抽象实现
abstract class FileInfo<T extends XEntity> extends Entity<T>
    implements IFileInfo<T> {
  FileInfo(T metadata, this.directory) : super(metadata) {
    this.isContainer = false;
    this.cache = XCache(fullId: '${this.spaceId}_${metadata.id}');
    Future.delayed(Duration(milliseconds: id == userId ? 100 : 0), () async {
      await loadUserData();
    });
  }

  @override
  late XCache cache;
  @override
  late bool isContainer;
  @override
  late IDirectory directory;

  @override
  bool get isInherited => directory.isInherited;

  ITarget get target {
    if (directory.typeName == '目录') {
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
  Future<bool> delete();

  @override
  Future<bool> rename(String name);

  @override
  Future<bool> copy(IDirectory destination);

  @override
  Future<bool> move(IDirectory destination);

  Future<void> loadUserData() async {
    final data = await target.user.cacheObj.get<XCache>(cachePath);
    if (data.fullId == cache.fullId) {
      cache = data;
    }
    target.user.cacheObj.subscribe(cachePath, (XCache data) {
      if (data.fullId == cache.fullId) {
        cache = data;
        target.user.cacheObj.setValue(cachePath, data);
        directory.changCallback();
        command.emitterFlag(flag: cacheFlag);
      }
    }, id: data.fullId);
  }

  @override
  Future<bool> cacheUserData({bool? notify = true}) async {
    final success = await target.user.cacheObj.set(cachePath, cache);
    if (success && notify!) {
      await target.user.cacheObj
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
  List<IFileInfo<XEntity>> content({int? mode = 0}) {
    return [];
  }

  @override
  List<OperateModel> operates({int? mode = 0}) {
    final operates = super.operates(mode: mode);
    if (mode! % 2 == 0) {
      if (target.space.hasRelationAuth()) {
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

/// 系统文件接口
abstract class ISysFileInfo extends IFileInfo<XEntity> {
  /// 文件系统项对应的目标
  late FileItemModel filedata;

  /// 分享信息
  FileItemShare shareInfo();
}

/// 文件转实体
XEntity fileToEntity(
  FileItemModel data,
  String belongId,
  XTarget? belong,
) {
  return XEntity(
    id: data.shareLink!.substring(1),
    name: data.name,
    code: data.key,
    icon: data.toJson().toString(),
    belongId: belongId,
    typeName: data.contentType,
    createTime: data.dateCreated,
    updateTime: data.dateModified,
    belong: belong,
  );
}

/// 文件类实现
class SysFileInfo extends FileInfo<XEntity> implements ISysFileInfo {
  SysFileInfo(FileItemModel metadata, IDirectory directory)
      : filedata = metadata,
        super(
          fileToEntity(
              metadata, directory.metadata.belongId, directory.metadata.belong),
          directory,
        );

  @override
  String get cacheFlag => 'files';

  @override
  FileItemModel filedata;

  @override
  FileItemShare shareInfo() {
    return FileItemShare(
      size: filedata.size,
      name: filedata.name,
      extension: filedata.extension,
      contentType: filedata.contentType,
      shareLink: filedata.shareLink,
      thumbnail: filedata.thumbnail,
    );
  }

  @override
  Future<bool> rename(String name) async {
    if (filedata.name != name) {
      final res = await directory.resource
          .bucketOpreate<FileItemModel>(BucketOpreateModel(
        name: name,
        key: encodeKey(filedata.key),
        operate: BucketOpreates.rename,
      ));
      if (res.success && res.data != null) {
        filedata = res.data!;
        return true;
      }
    }
    return false;
  }

  @override
  Future<bool> delete() async {
    final res = await directory.resource.bucketOpreate<List<FileItemModel>>(
      BucketOpreateModel(
        key: encodeKey(filedata.key),
        operate: BucketOpreates.delete,
      ),
    );
    if (res.success) {
      directory.files.removeWhere((i) => i.key == key);
    }
    return res.success;
  }

  @override
  Future<bool> copy(IDirectory destination) async {
    if (destination.id != directory.id) {
      final res = await directory.resource.bucketOpreate<List<FileItemModel>>(
        BucketOpreateModel(
          key: encodeKey(filedata.key),
          destination: destination.id,
          operate: BucketOpreates.copy,
        ),
      );
      if (res.success) {
        destination.files.add(this);
      }
      return res.success;
    }
    return false;
  }

  @override
  Future<bool> move(IDirectory destination) async {
    if (destination.id != directory.id) {
      final res = await directory.resource.bucketOpreate<List<FileItemModel>>(
        BucketOpreateModel(
          key: encodeKey(filedata.key),
          destination: destination.id,
          operate: BucketOpreates.move,
        ),
      );
      if (res.success) {
        directory.files.removeWhere((i) => i.key == key);
        directory = destination;
        destination.files.add(this);
      }
      return res.success;
    }
    return false;
  }

  @override
  List<OperateModel> operates({int? mode}) {
    final operates = super.operates();
    return operates.where((i) => i.cmd != 'update').toList();
  }

  @override
  List<IFileInfo<XEntity>> content({int? mode}) {
    return [];
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

abstract class IStandardFileInfo<T extends XStandard> implements IFileInfo<T> {
  Future<bool> notify(String operate, List<XEntity> data);
  Future<bool> update(T data);
}

abstract class StandardFileInfo<T extends XStandard> extends FileInfo<T>
    implements IStandardFileInfo<T> {
  XCollection<T> coll;

  StandardFileInfo(T metadata, IDirectory directory, this.coll)
      : super(metadata, directory);

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
  Future<bool> delete() async {
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
}
