import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/market/model.dart';
import 'package:orginone/dart/core/store/ifilesys.dart';
import 'package:uuid/uuid.dart';

/// 分片大小
const chunkSize = 1024 * 1024;

/*
 * 文件系统项实现
 */
class FileSystemItem implements IFileSystemItem {
  @override
  String fullKey;

  @override
  String key;

  @override
  String name;

  @override
  bool isRoot;

  @override
  FileItemModel target;

  @override
  IObjectItem? parent;

  @override
  List<IFileSystemItem> children;

  String belongId;
  List<TaskModel> _taskList = [];

  FileSystemItem({
    required this.target,
    this.parent,
    required String id,
  })  : children = [],
        key = target.key,
        name = target.name,
        isRoot = parent == null,
        belongId = id,
        fullKey = "$id-${target.key}";

  @override
  set taskList(List<TaskModel>? taskList) {
    _taskList = taskList!;
  }

  @override
  List<TaskModel> get taskList => _taskList;

  @override
  FileItemShare shareInfo() {
    return FileItemShare(
      size: target.size,
      name: target.name,
      extension: target.extension,
      shareLink: '/orginone/anydata/bucket/load/${target.shareLink}',
      thumbnail: target.thumbnail,
    );
  }

  @override
  set childrenData(List<FileItemModel>? childrenData) {
    childrenData = childrenData;
  }

  @override
  List<FileItemModel> get childrenData =>
      (children.map((item) => (item.target)).toList());

  @override
  Future<bool> rename(String name) async {
    if (this.name != name && (await _findByName(name)) != null) {
      var res = await kernel.anystore.bucketOpreate(BucketOpreateModel(
        name: name,
        key: _formatKey(),
        operate: BucketOpreates.rename,
      ));
      if (res.success && res.data != null) {
        target = res.data;
        key = res.data!.key;
        name = res.data!.name;
        return true;
      }
    }
    return false;
  }

  @override
  Future<IObjectItem> create(String name) async {
    var exist = await _findByName(name);
    if (exist == null) {
      var res = await kernel.anystore.bucketOpreate(BucketOpreateModel(
        key: _formatKey(subName: name),
        operate: BucketOpreates.create,
      ));
      if (res.success && res.data != null) {
        target.hasSubDirectories = true;
        var node = FileSystemItem(
          target: FileItemModel.formJson(res.data),
          parent: this,
          id: belongId,
        );
        children.add(node);
        return node;
      }
    }
    return exist!;
  }

  @override
  Future<bool> delete() async {
    var res = await kernel.anystore.bucketOpreate(BucketOpreateModel(
      key: _formatKey(),
      operate: BucketOpreates.delete,
    ));
    if (res.success) {
      var index = parent?.children.indexWhere((item) => item.key == key);
      if (index != null && index > -1) {
        parent?.children.removeAt(index);
      }
      return true;
    }
    return false;
  }

  @override
  Future<bool> copy(IFileSystemItem destination) async {
    if (destination.target.isDirectory && key != destination.key) {
      var res = await kernel.anystore.bucketOpreate(BucketOpreateModel(
        key: _formatKey(),
        destination: destination.key,
        operate: BucketOpreates.copy,
      ));
      if (res.success) {
        destination.target.hasSubDirectories = true;
        destination.children.add(_newItemForDes(this, destination));
        return true;
      }
    }
    return false;
  }

  @override
  Future<bool> move(IFileSystemItem destination) async {
    if (destination.target.isDirectory && key != destination.key) {
      var res = await kernel.anystore.bucketOpreate(BucketOpreateModel(
        key: _formatKey(),
        destination: destination.key,
        operate: BucketOpreates.move,
      ));
      if (res.success) {
        var index = parent?.children.indexWhere((item) => item.key == key);
        if (index != null && index > -1) {
          parent?.children.removeAt(index);
        }
        destination.target.hasSubDirectories = true;
        destination.children.add(_newItemForDes(this, destination));
        return true;
      }
    }
    return false;
  }

  @override
  Future<bool> loadChildren({bool? reload}) async {
    reload ??= false;
    if (target.isDirectory && (reload || children.isEmpty)) {
      var res = await kernel.anystore.bucketOpreate(BucketOpreateModel(
        key: _formatKey(),
        operate: BucketOpreates.list,
      ));
      print('key---------${_formatKey()}');
      if (res.success && res.data!.isNotEmpty) {
        for (var json in res.data!) {
          children ??= [];
          children.add(FileSystemItem(
            target: FileItemModel.formJson(json),
            parent: this,
            id: belongId,
          ));
        }
        return true;
      }
    }
    return false;
  }

  //TODO:需要验证
  @override
  Future<IObjectItem> upload(String name, File file,
      [OnProgressType? p]) async {
    var exist = await _findByName(name);
    if (exist == null) {
      p?.call(0);
      var task = TaskModel(
          name: name,
          finished: 0,
          size: file.lengthSync().floorToDouble(),
          createTime: DateTime.now(),
          group: this.name);

      _taskList.add(task);
      var data = BucketOpreateModel(
        key: _formatKey(subName: name),
        operate: BucketOpreates.upload,
      );
      String uuid = const Uuid().v1();
      int index = 0;
      while (index * chunkSize < file.lengthSync().floorToDouble()) {
        var start = index * chunkSize;
        var end = start + chunkSize;
        if (end > file.lengthSync().floorToDouble()) {
          end = file.lengthSync();
        }
        List<int> bytes = file.readAsBytesSync();
        bytes = bytes.sublist(start, end);
        String url = base64.encode(bytes);
        data.fileItem = FileChunkData(
          index: index,
          uploadId: uuid,
          size: file.lengthSync(),
          data: [],
          dataUrl: url,
        );
        var res = await kernel.anystore.bucketOpreate(data);
        if (!res.success) {
          data.operate = BucketOpreates.abortUpload;
          await kernel.anystore.bucketOpreate(data);
          task.finished = -1;
          p?.call(-1);
          // return;
        }
        index++;
        task.finished = end.toDouble();
        p?.call(end.toDouble());
        if (end == file.lengthSync() && res.data != null) {
          var node = FileSystemItem(
            target: FileItemModel.formJson(res.data),
            parent: this,
            id: belongId,
          );
          children.add(node);
          return node;
        }
      }
    }
    return exist!;
  }

  @override
  Future<Void> download(String path, OnProgressType onProgress) {
    throw Error();
  }

  ///判断url是否含有中文，有则进行urlencode
  bool isChinese(String value) {
    return RegExp(r"[\u4e00-\u9fa5]").hasMatch(value);
  }

  /// 格式化key,主要针对路径中的中文
  /// @returns 格式化后的key
  _formatKey({String subName = ''}) {
    if (target?.key == null && subName == '') {
      return '';
    }
    try {
      var keys = target?.key != null ? [target!.key] : [];
      if (subName.isNotEmpty) {
        keys.add(subName);
      }
      print('base64------------${base64.encode(utf8.encode(keys.join('/')))}');
      return base64.encode(utf8.encode(keys.join('/')));
    } catch (err) {
      return '';
    }
  }

  /// 根据名称查询子文件系统项
  /// @param name 名称
  Future<IFileSystemItem?> _findByName(String name) async {
    await loadChildren();
    for (var item in children) {
      if (item.target.name.split('/').last == name) {
        return item;
      }
    }

    return null;
  }

  // /**
  //  * 根据新目录生成文件系统项
  //  * @param source 源
  //  * @param destination 目标
  //  * @returns 新的文件系统项
  //  */
  IFileSystemItem _newItemForDes(
    IFileSystemItem source,
    IFileSystemItem destination,
  ) {
    var node = FileSystemItem(
      parent: destination,
      target: FileItemModel(
        size: source.target.size,
        key: '${destination.key}/${source.name}',
        name: source.name,
        dateCreated: DateTime.now(),
        dateModified: DateTime.now(),
        shareLink: source.target.shareLink,
        extension: source.target.extension,
        thumbnail: source.target.thumbnail,
        isDirectory: source.target.isDirectory,
        contentType: source.target.contentType,
        hasSubDirectories: source.target.hasSubDirectories,
      ),
      id: belongId,
    );

    for (var item in source.children) {
      node.children.add(_newItemForDes(item, node));
    }
    return node;
  }
}

/* 获取文件系统的根 */
var getFileSysItemRoot = (belongId) => FileSystemItem(
  target: FileItemModel(
    key: '',
    size: 0,
    name: '根目录',
    isDirectory: true,
    extension: '',
    thumbnail: '',
    shareLink: '',
    contentType: '',
    hasSubDirectories: true,
    dateCreated: DateTime.now(),
    dateModified: DateTime.now(),
  ),
  id: belongId,
);
