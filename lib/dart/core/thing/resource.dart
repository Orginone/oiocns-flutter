import 'dart:convert';
import 'dart:io';

import 'package:orginone/dart/base/common/format.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/public/collection.dart';
import 'package:orginone/main_base.dart';
import 'package:orginone/utils/index.dart';
import 'package:uuid/uuid.dart';

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

  /// 页面模板集合
  late XCollection<XPageTemplate> templateColl;

  /// 暂存集合
  late XCollection<XStaging> stagingColl;

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
    templateColl = genTargetColl<XPageTemplate>('standard-page-template');
    stagingColl = genTargetColl<XStaging>('resource-staging');
  }

  /// 资源预加载
  Future<void> preLoad({bool reload = false}) async {
    if (!_proLoaded || reload) {
      await Future.wait([
        // formColl.all(reload: reload, fromJson: XForm.fromJson),
        // speciesColl.all(reload: reload, fromJson: XSpecies.fromJson),
        // propertyColl.all(reload: reload, fromJson: XProperty.fromJson),
        // transferColl.all(reload: reload, fromJson: XTransfer.fromJson),
        directoryColl.all(reload: reload, fromJson: XDirectory.fromJson),
        applicationColl.all(reload: reload, fromJson: XApplication.fromJson),
        templateColl.all(reload: reload, fromJson: XPageTemplate.fromJson),
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
  Future<ResultType<R>> bucketOpreate<R>(BucketOpreateModel data,
      [R Function(Map<String, dynamic>)? cvt]) async {
    return await kernel.bucketOpreate<R>(
        target.belongId!, relations, data, cvt);
  }

  /// 删除文件目录
  Future<void> deleteDirectory(String directoryId) async {
    await bucketOpreate(BucketOpreateModel(
      key: encodeKey(directoryId),
      operate: BucketOpreates.delete,
    ));
  }

  /// 上传文件
  Future<FileItemModel?> fileUpdate(File file, String key,
      {void Function(double)? progress}) async {
    var id = const Uuid().v1();
    final data = BucketOpreateModel(
      key: encodeKey(key),
      operate: BucketOpreates.upload,
    );
    progress?.call(0);

    int chunkSize = 1024 * 1024;
    int fileLength = file.lengthSync();
    final slices = await sliceFile(file, chunkSize);
    for (var i = 0; i < slices.length; i++) {
      final s = slices[i];
      data.fileItem = FileChunkData(
        index: i,
        uploadId: id,
        size: file.lengthSync(),
        data: [],
        dataUrl: await fileToDataUrl(s),
      );
      final res = await bucketOpreate<FileItemModel>(
          data, (a) => FileItemModel.fromJson(a));
      // LogUtil.d('bucketOpreate');
      // LogUtil.d(res.toJson());
      LogUtil.d(res.data?.toJson());
      if (!res.success) {
        data.operate = BucketOpreates.abortUpload;
        await bucketOpreate<bool>(data);
        progress?.call(-1);
        return null;
      }
      final finished = i * chunkSize + s.length;
      // progress(finished.toDouble());
      if (finished == fileLength && res.data != null) {
        progress?.call(1);
        return res.data;
      }
    }
    return null;
  }

  Future<FileItemModel?> fileUpdate2(File file, String key,
      {void Function(double)? progress}) async {
    var id = const Uuid().v1();
    final data = BucketOpreateModel(
      key: base64.encode(utf8.encode(key)),
      operate: BucketOpreates.upload,
    );
    progress?.call(0);
    int index = 0;
    int chunkSize = 1024 * 1024;
    int fileLength = file.lengthSync();
    while (index * chunkSize < fileLength.floorToDouble()) {
      var start = index * chunkSize;
      var end = start + chunkSize;
      if (end > fileLength.floorToDouble()) {
        end = fileLength;
      }
      List<int> bytes = file.readAsBytesSync();
      bytes = bytes.sublist(start, end);
      String url = base64.encode(bytes);
      data.fileItem = FileChunkData(
        index: index,
        uploadId: id,
        size: fileLength,
        data: [],
        dataUrl: url,
      );
      var res = await bucketOpreate(data);
      if (!res.success) {
        data.operate = BucketOpreates.abortUpload;
        await bucketOpreate(data);
        progress?.call(-1);
        return null;
      }
      index++;
      progress?.call(end / fileLength);
      if (end == fileLength && res.data != null) {
        var node = FileItemModel.fromJson(res.data);
        return node;
      }
    }
    return null;
  }
}
