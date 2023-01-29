import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:convert' as convert;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:orginone/core/base/api/any_store.dart';
import 'package:orginone/core/base/api/kernelapi.dart';
import 'package:orginone/core/base/model.dart';
import 'package:orginone/config/constant.dart';
import 'package:orginone/core/store/i_file_system.dart';
import 'package:orginone/enumeration/bucket_operates.dart';
import 'package:uuid/uuid.dart';

class FileSystemItem implements IFileSystemItem {
  /** 分片大小 */
  final int chunkSize = 1024 * 1024;
  final String _key;
  final String _name;
  final FileItemModel _target;
  final IFileSystemItem? _parent;
  final RxList<IFileSystemItem> _children;

  @override
  List<IFileSystemItem> get children => _children;

  @override
  String get key => _key;

  @override
  String get name => _name;

  @override
  IFileSystemItem? get parent => _parent;

  @override
  FileItemModel get target => _target;

  FileSystemItem({
    required FileItemModel target,
    IFileSystemItem? parent,
  })  : _key = target.key,
        _name = target.name,
        _target = target,
        _parent = parent,
        _children = <IFileSystemItem>[].obs;

  String _formatKey({String subName = ""}) {
    var keys = [target.key];
    if (subName.isNotEmpty) {
      keys.add("/");
      keys.add(subName);
    }
    var res = "";
    for (var element in keys) {
      res = res + element;
    }
    var content = convert.utf8.encode(res);
    var digest = convert.base64Encode(content);
    return digest;
  }

  IFileSystemItem _newItemForDes({
    required IFileSystemItem source,
    required IFileSystemItem destination,
  }) {
    var node = FileSystemItem(
      target: FileItemModel(
        name: source.name,
        dateCreated: DateTime.now(),
        dateModified: DateTime.now(),
        size: source.target.size,
        shareLink: source.target.shareLink,
        extension: source.target.extension,
        thumbnail: source.target.thumbnail,
        key: "${destination.key}/${source.name}",
        contentType: source.target.contentType,
        isDirectory: source.target.isDirectory,
        hasSubDirectories: source.target.hasSubDirectories,
      ),
      parent: source,
    );
    for (var item in node.children) {
      node._children.add(_newItemForDes(source: item, destination: node));
    }
    return node;
  }

  @override
  FileItemShare shareInfo() {
    return FileItemShare(
      size: target.size,
      name: target.name,
      shareLink: "${Constant.bucket}/load/${target.shareLink}",
      extension: target.extension,
      thumbnail: target.thumbnail,
    );
  }

  @override
  Future<bool> copy(IFileSystemItem destination) async {
    if (destination.target.isDirectory && _key != destination.key) {
      await Kernel.getInstance.anyStore.bucketOperate(BucketOperateModel(
        key: _formatKey(),
        shareDomain: Domain.user.name,
        destination: destination.key,
        operate: BucketOperates.copy.keyWord,
      ));
      destination.target.hasSubDirectories = true;
      destination.children
          .add(_newItemForDes(source: this, destination: destination));
      return true;
    }
    return false;
  }

  @override
  Future<IFileSystemItem?> create(String name) async {
    var exit = await _findByName(name);
    if (exit == null) {
      var res = await Kernel.getInstance.anyStore.bucketOperate(
          BucketOperateModel(
              shareDomain: 'user',
              key: _formatKey(subName: name),
              operate: BucketOperates.create.keyWord));
      if (res.success && res.data != null) {
        target.hasSubDirectories = true;
        var node = FileSystemItem(target: mapToFileItemModel(res.data), parent: this);
        _children.add(node);
        return node;
      }
    }
    return exit;
  }

  @override
  Future<bool> delete() {
    throw UnimplementedError();
  }

  @override
  Future<void> download(String path, Function(double p1) onProgress) {
    throw UnimplementedError();
  }

  @override
  Future<bool> loadChildren(bool reload) async {
    if (_target.isDirectory && (reload || _children.isEmpty)) {
      var res =
          await Kernel.getInstance.anyStore.bucketOperate(BucketOperateModel(
        key: _formatKey(),
        shareDomain: 'user',
        operate: BucketOperates.list.keyWord,
      ));
      if (res.success && res.data.length > 0) {
        var list = <IFileSystemItem>[];
        res.data.forEach((value) {
          debugPrint("keys === ${value["key"]}");
          list.add(FileSystemItem(target: mapToFileItemModel(value), parent: this));
        });
        _children.value = list;
      }
      return true;
    }
    return false;
  }

  @override
  Future<bool> move(IFileSystemItem destination) {
    throw UnimplementedError();
  }

  @override
  Future<bool> rename(String name) {
    throw UnimplementedError();
  }

  /// 分片上传
  @override
  Future<IFileSystemItem?> upload({
    required String name,
    required File file,
    required Function(double) onProgress,
  }) async {
    var exit = await _findByName(name);
    if (exit == null) {
      onProgress.call(0);
      var data = BucketOperateModel(
          key: _formatKey(subName: name),
          shareDomain: 'user',
          operate: BucketOperates.upload.keyWord);
      var id = const Uuid().v1();
      var index = 0;
      var size = await file.length();
      var activeFile = await file.readAsBytes();
      while (index * chunkSize < size) {
        var start = index * chunkSize;
        var end = start + chunkSize;
        if (end > size) {
          end = size;
        }
        debugPrint("size:$size |start:$start |end:$end");
        var base64 = base64Encode(activeFile.sublist(start, end));
        data.fileItem = FileChunkData(
            index: index, size: size, uploadId: id, data: [], dataUrl: base64);
        var res = await Kernel.getInstance.anyStore.bucketOperate(data);
        if (!res.success) {
          data.operate = BucketOperates.abortUpload.keyWord;
          await Kernel.getInstance.anyStore.bucketOperate(data);
          //上传失败回调 -1
          onProgress.call(-1);
          return null;
        }
        index++;
        onProgress.call(end.toDouble());
        if (end == size && res.data != null) {
          var node = FileSystemItem(target: mapToFileItemModel(res.data), parent: this);
          children.add(node);
          return node;
        }
      }
    }
    return exit;
  }

  /// 由于返回的是dynamic类型，需要手动转为FileItemModel
  FileItemModel mapToFileItemModel(LinkedHashMap<String, dynamic> value) {
    return FileItemModel(
        size: value["size"],
        name: value["name"],
        shareLink: value["shareLink"],
        extension: value["extension"],
        thumbnail: value["thumbnail"],
        key: value["key"],
        dateCreated: DateTime.parse(value["dateCreated"]),
        dateModified: DateTime.parse(value["dateModified"]),
        contentType: value["contentType"],
        hasSubDirectories: value["hasSubDirectories"],
        isDirectory: value["isDirectory"]);
  }

  Future<IFileSystemItem?> _findByName(String name) async {
    var res = await loadChildren(false);
    for (var element in children) {
      debugPrint("--->key = ${element.key} name = ${element.name} + |  $name");
      if (element.name == name) {
        return element;
      }
    }
    return null;
  }

}
