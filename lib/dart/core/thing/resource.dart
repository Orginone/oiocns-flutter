import 'dart:typed_data';

import 'package:orginone/dart/base/common/entity.dart';
import 'package:orginone/dart/base/common/format.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/public/collection.dart';
import 'package:orginone/main.dart';

/// 数据核资源（前端开发）
class DataResource {
  late List<String> _keys;
  late XTarget target;
  late List<String> relations;
  bool _proLoaded = false;

  /// 表单集合
  late XCollection<XForm> formColl;

  /// 属性集合
  late XCollection<XProperty> propertyColl;

  /// 分类集合
  late XCollection<XSpecies> speciesColl;

  /// 类目集合
  late XCollection<XSpeciesItem> speciesItemColl;

  /// 应用集合
  late XCollection<XApplication> applicationColl;

  /// 资源目录集合
  late XCollection<XDirectory> directoryColl;

  /// 群消息集合
  late XCollection<ChatMessageType> messageColl;

  /// 数据传输配置集合
  late XCollection<XTransfer> transferColl;

  /// 资源对应的用户信息
  XTarget get targetMetadata => target;

  /// 数据核资源的构造函数
  DataResource(this.target, this.relations, List<String> keys) {
    _keys = keys;
    formColl = genTargetColl<XForm>('standard-form');
    transferColl = genTargetColl<XTransfer>('standard-transfer');
    speciesColl = genTargetColl<XSpecies>('standard-species');
    messageColl = genTargetColl<ChatMessageType>('chat-messages');
    propertyColl = genTargetColl<XProperty>('standard-property');
    directoryColl = genTargetColl<XDirectory>('resource-directory');
    applicationColl = genTargetColl<XApplication>('standard-application');
    speciesItemColl = genTargetColl<XSpeciesItem>('standard-species-item');
  }

  /// 资源预加载
  Future<void> preLoad({bool reload = false}) async {
    if (!_proLoaded || reload) {
      await Future.wait([
        formColl.all(reload: reload),
        speciesColl.all(reload: reload),
        propertyColl.all(reload: reload),
        transferColl.all(reload: reload),
        directoryColl.all(reload: reload),
        applicationColl.all(reload: reload),
      ]);
    }
    _proLoaded = true;
  }

  /// 生成集合
  XCollection<T> genColl<T extends Xbase>(String collName,
      [List<String>? relations]) {
    return XCollection<T>(
      target,
      collName,
      relations ?? this.relations,
      _keys,
    );
  }

  /// 生成用户类型的集合
  XCollection<T> genTargetColl<T extends Xbase>(String collName) {
    return XCollection<T>(target, collName, relations, _keys);
  }

  /// 文件桶操作
  Future<ResultType<R>> bucketOpreate<R>(BucketOpreateModel data) async {
    return await kernel.bucketOpreate<R>(target.belongId!, relations, data);
  }

  /// 上传文件
  Future<FileItemModel?> fileUpdate(
    Uint8List file,
    String key,
    void Function(double) progress,
  ) async {
    const id = uuid;
    final data = BucketOpreateModel(
      key: encodeKey(key),
      operate: BucketOpreates.upload,
    );
    progress(0);
    final slices = sliceFile(file, 1024 * 1024);
    for (var i = 0; i < slices.length; i++) {
      final s = slices[i];
      data.fileItem = FileChunkData(
        index: i,
        uploadId: id.v1(),
        size: file.length,
        data: [],
        dataUrl: await blobToDataUrl(s),
      );
      final res = await bucketOpreate<FileItemModel>(data);
      if (!res.success) {
        data.operate = BucketOpreates.abortUpload;
        await bucketOpreate<bool>(data);
        progress(-1);
        return null;
      }
      final finished = i * 1024 * 1024 + s.length;
      progress(finished.toDouble());
      if (finished == file.length && res.data != null) {
        return res.data;
      }
    }
    return null;
  }
}