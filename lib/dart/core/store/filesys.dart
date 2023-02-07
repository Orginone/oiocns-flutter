import 'dart:io';

import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/market/model.dart';
import './ifilesys.dart';

/// 分片大小
const chunkSize = 1024 * 1024;

/*
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
  List<TaskModel> get taskList => _taskList;

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
      if (res.success && res.data != null) {
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
      if (res.success && res.data != null) {
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
    if (res.success) {
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
      if (res.success) {
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
      if (res.success) {
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
      if (res.success && res.data!.isNotEmpty) {
        children = res.data!
            .map((item) => FileSystemItem(target: item, parent: parent))
            .toList();
        return true;
      }
    }
    return false;
  }
  //TODO:需要验证翻
  // Future<IObjectItem> upload(String name, File file, [OnProgressType? p]) async {
  //   var exist = await _findByName(name);
  //   if (exist !=null) {
  //     p?.apply(this, [0]);
  //     var task= TaskModel (name: name,
  //       finished: 0,
  //       size: file..,
  //       createTime: DateTime.now(),
  //       group: this.name);

  //     FileSystemItem._taskList.push(task);
  //     let data: BucketOpreateModel = {
  //       shareDomain: 'user',
  //       key: this._formatKey(name),
  //       operate: BucketOpreates.Upload,
  //     };
  //     const id = generateUuid();
  //     let index = 0;
  //     while (index * chunkSize < file.size) {
  //       var start = index * chunkSize;
  //       var end = start + chunkSize;
  //       if (end > file.size) {
  //         end = file.size;
  //       }
  //       data.fileItem = {
  //         index: index,
  //         uploadId: id,
  //         size: file.size,
  //         data: [],
  //         dataUrl: await blobToDataUrl(file.slice(start, end)),
  //       };
  //       const res = await kernel.anystore.bucketOpreate<FileItemModel>(data);
  //       if (!res.success) {
  //         data.operate = BucketOpreates.AbortUpload;
  //         await kernel.anystore.bucketOpreate<boolean>(data);
  //         task.finished = -1;
  //         p?.apply(this, [-1]);
  //         return;
  //       }
  //       index++;
  //       task.finished = end;
  //       p?.apply(this, [end]);
  //       if (end === file.size && res.data) {
  //         const node = new FileSystemItem(res.data, this);
  //         this.children.push(node);
  //         return node;
  //       }
  //     }
  //   }
  //   return exist;
  // }
  // download(path: string, onProgress: OnProgressType): Promise<void> {
  //   throw new Error('Method not implemented.');
  // }

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
