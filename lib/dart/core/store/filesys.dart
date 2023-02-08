import 'dart:ffi';
import 'dart:io';

import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/market/model.dart';
import 'package:uuid/uuid.dart';
import './ifilesys.dart';

/// 分片大小
const chunkSize = 1024 * 1024;

/**
 * 文件系统项实现
 */
class FileSystemItem implements IFileSystemItem {
  @override
  String? key;

  @override
  String? name;

  @override
  bool? isRoot;

  @override
  FileItemModel? target;
  @override
  IObjectItem? parent;

  @override
  List<IFileSystemItem>? children;
  List<TaskModel> _taskList = [];

  FileSystemItem(
      {this.key,
      this.name,
      this.isRoot,
      this.target,
      this.parent,
      this.children});

  @override
  set taskList(List<TaskModel>? taskList) {
    _taskList = taskList!;
  }

  @override
  List<TaskModel>? get taskList => _taskList;

//TODO:浏览器location.origin 获取浏览器地址需要重新 在flutter中实现
//Location.origin + '/orginone/anydata/bucket/load/' + target?.shareLink,
  @override
  FileItemShare shareInfo() {
    return FileItemShare(
      size: target?.size,
      name: target?.name,
      extension: target?.extension,
      shareLink: '/orginone/anydata/bucket/load/${target?.shareLink}',
      thumbnail: target?.thumbnail,
    );
  }

  @override
  set childrenData(List<FileItemModel>? _childrenData) {
    childrenData = _childrenData;
  }

  @override
  List<FileItemModel>? get childrenData =>
      (children?.map((item) => (item.target!)).toList());

  @override
  Future<bool> rename(String name) async {
    if (this.name != name && (await _findByName(name)) != null) {
      var res =
          await kernel.anystore.bucketOpreate<FileItemModel>(BucketOpreateModel(
        name: name,
        shareDomain: 'user',
        key: _formatKey(),
        operate: BucketOpreates.rename,
      ));
      if (res.success! && res.data != null) {
        target = res.data;
        key = res.data!.key;
        name = res.data!.name!;
        return true;
      }
    }
    return false;
  }

  @override
  Future<IObjectItem> create(String name) async {
    var exist = await _findByName(name);
    if (exist != null) {
      var res =
          await kernel.anystore.bucketOpreate<FileItemModel>(BucketOpreateModel(
        shareDomain: 'user',
        key: _formatKey(subName: name),
        operate: BucketOpreates.create,
      ));
      if (res.success! && res.data != null) {
        target!.hasSubDirectories = true;
        var node = FileSystemItem(target: res.data, parent: parent);
        children!.add(node);
        return node;
      }
    }
    return exist!;
  }

  @override
  Future<bool> delete() async {
    var res = await kernel.anystore
        .bucketOpreate<List<FileItemModel>>(BucketOpreateModel(
      shareDomain: 'user',
      key: _formatKey(),
      operate: BucketOpreates.delete,
    ));
    if (res.success!) {
      var index = parent?.children!.indexWhere((item) => item.key == key);
      if (index != null && index > -1) {
        parent?.children!.removeAt(index);
      }
      return true;
    }
    return false;
  }

  @override
  Future<bool> copy(IFileSystemItem destination) async {
    if (destination.target!.isDirectory! && key != destination.key) {
      var res = await kernel.anystore
          .bucketOpreate<List<FileItemModel>>(BucketOpreateModel(
        shareDomain: 'user',
        key: _formatKey(),
        destination: destination.key,
        operate: BucketOpreates.copy,
      ));
      if (res.success!) {
        destination.target?.hasSubDirectories = true;
        destination.children?.add(_newItemForDes(this, destination));
        return true;
      }
    }
    return false;
  }

  @override
  Future<bool> move(IFileSystemItem destination) async {
    if (destination.target!.isDirectory! && key != destination.key) {
      var res = await kernel.anystore
          .bucketOpreate<List<FileItemModel>>(BucketOpreateModel(
        shareDomain: 'user',
        key: _formatKey(),
        destination: destination.key,
        operate: BucketOpreates.move,
      ));
      if (res.success!) {
        var index = parent?.children!.indexWhere((item) => item.key == key);
        if (index != null && index > -1) {
          parent?.children!.removeAt(index);
        }
        destination.target!.hasSubDirectories = true;
        destination.children!.add(_newItemForDes(this, destination));
        return true;
      }
    }
    return false;
  }

  @override
  Future<bool> loadChildren({bool? reload}) async {
    reload ??= false;
    if (target!.isDirectory! && (reload || children!.isEmpty)) {
      var res = await kernel.anystore
          .bucketOpreate<List<FileItemModel>>(BucketOpreateModel(
        shareDomain: 'user',
        key: _formatKey(),
        operate: BucketOpreates.list,
      ));
      if (res.success! && res.data!.isNotEmpty) {
        children = res.data!
            .map((item) => FileSystemItem(target: item, parent: parent))
            .toList();
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
    if (exist != null) {
      p?.call(0);
      var task = TaskModel(
          name: name,
          finished: 0,
          size: file.lengthSync().floorToDouble(),
          createTime: DateTime.now(),
          group: this.name);

      _taskList.add(task);
      var data = BucketOpreateModel(
        shareDomain: 'user',
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
        data.fileItem = FileChunkData(
          index: index,
          uploadId: uuid,
          size: file.lengthSync(),
          data: [],
          // dataUrl: await blobToDataUrl(file.slice(start, end)),
        );
        var res = await kernel.anystore.bucketOpreate<FileItemModel>(data);
        if (!res.success!) {
          data.operate = BucketOpreates.abortUpload;
          await kernel.anystore.bucketOpreate<bool>(data);
          task.finished = -1;
          p?.call(-1);
          // return;
        }
        index++;
        task.finished = end as double?;
        p?.call(end as double);
        if (end == file.lengthSync() && res.data != null) {
          var node = FileSystemItem(target: res.data, parent: this);
          children!.add(node);
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
  _formatKey({String? subName}) {
    if (target?.key != null && subName != null) {
      return '';
    }
    try {
      var keys = target?.key != null ? [] : [target!.key];
      if (subName != '' && subName!.isNotEmpty) {
        String outputUrl = subName;
        bool boolIsChinese = isChinese(subName);
        if (Platform.isIOS && boolIsChinese) {
          outputUrl = Uri.encodeFull(subName);
        } else {}
        return keys.add(subName);
      }

//TODO:格式化key,主要针对路径中的中文 可能不对
      // return btoa(unescape(encodeURIComponent(keys.join('/'))));
    } catch (err) {
      return '';
    }
  }

  /// 根据名称查询子文件系统项
  /// @param name 名称
  Future<IFileSystemItem?> _findByName(String name) async {
    await loadChildren();

    for (var item in children!) {
      if (item.name == name) {
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
      name: source.name,
      parent: destination,
      target: FileItemModel(
        size: source.target?.size,
        key: '${destination.key}/${source.name}',
        name: source.name,
        dateCreated: DateTime.now(),
        dateModified: DateTime.now(),
        shareLink: source.target!.shareLink,
        extension: source.target!.extension,
        thumbnail: source.target!.thumbnail,
        isDirectory: source.target!.isDirectory,
        contentType: source.target!.contentType,
        hasSubDirectories: source.target!.hasSubDirectories,
      ),
    );

    for (var item in source.children!) {
      node.children!.add(_newItemForDes(item, node));
    }
    return node;
  }
}

/** 获取文件系统的根 */
var getFileSysItemRoot = FileSystemItem(
    key: "",
    name: "根目录",
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
    ));
