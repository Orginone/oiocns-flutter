import 'dart:convert';
import 'dart:io';

import 'package:orginone/config/constant.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/market/model.dart';
import 'package:uuid/uuid.dart';

import 'filesysItem.dart';

//分片大小
const chunkSize = 1024 * 1024;

//可为空的进度回调
typedef OnProgressType = void Function(double);

//文件系统目录接口
abstract class IFileSystemItem {
  //文件系统
  late IFileSystem filesys;

  //文件系统项对应的目标
  late FileItemModel metadata;

  //上级文件系统项
  IFileSystemItem? parent;

  //下级文件系统项数组
  late List<IFileSystemItem> children;

  //分享信息
  FileItemShare shareInfo();

  //创建文件系统项（目录）
  Future<IFileSystemItem?> create(String name);

  //删除文件系统项
  Future<bool> delete();

  //重命名
  Future<bool> rename(String name);

  //拷贝文件系统项（目录）
  Future<bool> copy(IFileSystemItem destination);

  //移动文件系统项（目录）
  Future<bool> move(IFileSystemItem destination);

  //加载下级文件系统项数组
  Future<bool> loadChildren([bool reload = false]);

  //上传文件
  Future<IFileSystemItem?> upload(String name, File file,
      [OnProgressType? onProgress]);
  //下载文件
  Future<void> download(String path, OnProgressType onProgress);
}

class FileSystemItem implements IFileSystemItem {
  FileSystemItem(this.filesys, this.metadata, [this.parent]) {
    children = [];
    belongId = filesys.belong.belongId;
  }

  @override
  late List<IFileSystemItem> children;

  late String belongId;

  @override
  IFileSystem filesys;

  @override
  FileItemModel metadata;

  @override
  IFileSystemItem? parent;

  @override
  Future<bool> copy(IFileSystemItem destination) async{
    if (destination.metadata.isDirectory && metadata.key != destination.metadata.key) {
      final res = await kernel.anystore.bucketOpreate(belongId, BucketOpreateModel( key: _formatKey(),
        destination: destination.metadata.key,
        operate: BucketOpreates.copy,));
      if (res.success) {
        destination.metadata.hasSubDirectories = true;
        destination.children.add(_newItemForDes(this, destination));
        return true;
      }
    }
    return false;
  }

  @override
  Future<IFileSystemItem?> create(String name) async{
    final exist = await _findByName(name);
    if (exist == null) {
      final res = await kernel.anystore.bucketOpreate(belongId,BucketOpreateModel(  key: _formatKey(subName: name),
        operate: BucketOpreates.create,));
      if (res.success && res.data != null) {
        metadata.hasSubDirectories = true;
        FileItemModel data = FileItemModel.fromJson(res.data!);
        final node = FileSystemItem(filesys, data, this);
        children.add(node);
        return node;
      }
    }
    return exist;
  }

  @override
  Future<bool> delete() async{
    final res = await kernel.anystore.bucketOpreate(belongId, BucketOpreateModel( key: _formatKey(),
      operate: BucketOpreates.delete,));
    if (res.success) {
      final index = parent?.children.indexWhere((item) => item.metadata.key == metadata.key);
      if (index != null && index > -1) {
        parent?.children.removeAt(index);
      }
      return true;
    }
    return false;
  }

  @override
  Future<void> download(String path, OnProgressType onProgress) {
    // TODO: implement download
    throw UnimplementedError();
  }

  @override
  Future<bool> loadChildren([bool reload = false]) async{
    if (metadata.isDirectory && (reload || children.isEmpty)) {
      final res = await kernel.anystore.bucketOpreate(belongId, BucketOpreateModel(
          key: _formatKey(),
        operate: BucketOpreates.list,
      ));
      if (res.success && res.data!=null) {
        List<FileItemModel> list = [];
        res.data.forEach((e) {
          list.add(FileItemModel.fromJson(e));
        });
        children = list.map((item) => FileSystemItem(filesys, item, this)).toList();
        return true;
      }
    }
    return children.isNotEmpty;
  }

  @override
  Future<bool> move(IFileSystemItem destination) async{
    if (destination.metadata.isDirectory && metadata.key != destination.metadata.key) {
      final res = await kernel.anystore.bucketOpreate(belongId, BucketOpreateModel(key: _formatKey(),
        destination: destination.metadata.key,
        operate: BucketOpreates.move,));
      if (res.success) {
        final index = parent?.children.indexWhere((item) => item.metadata.key == metadata.key);
        if (index != null && index > -1) {
          parent?.children.removeAt(index);
        }
        destination.metadata.hasSubDirectories = true;
        destination.children.add(_newItemForDes(this, destination));
        return true;
      }
    }
    return false;
  }

  @override
  Future<bool> rename(String name) async {
    if (metadata.name != name && (await _findByName(name)!=null)) {
      final res = await kernel.anystore.bucketOpreate(
          belongId,
          BucketOpreateModel(
            name: name,
            key: _formatKey(),
            operate: BucketOpreates.rename,
          ));
      if (res.success && res.data != null) {
        metadata = res.data!;
        return true;
      }
    }
    return false;
  }

  /// 根据名称查询子文件系统项
  /// @param name 名称
  Future<IFileSystemItem?> _findByName(String name) async {
    await loadChildren();
    for (var item in children) {
      if (item.metadata.name == name) {
        return item;
      }
    }

    return null;
  }

  @override
  FileItemShare shareInfo() {
    return FileItemShare(
      size: metadata.size,
      name: metadata.name,
      extension: metadata.extension,
      shareLink: '${Constant.host}/orginone/anydata/bucket/load/${metadata.shareLink}',
      thumbnail: metadata.thumbnail,
    );
  }

  @override
  Future<IFileSystemItem?> upload(String name, File file,
      [OnProgressType? onProgress]) async{
    var exist = await _findByName(name);
    if (exist == null) {
      onProgress?.call(0);
      var task = TaskModel(
          name: name,
          finished: 0,
          size: file.lengthSync(),
          createTime: DateTime.now(),
          group: metadata.name);


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
        var res = await kernel.anystore.bucketOpreate(belongId,data);
        if (!res.success) {
          data.operate = BucketOpreates.abortUpload;
          await kernel.anystore.bucketOpreate(belongId,data);
          task.finished = -1;
          onProgress?.call(-1);
          return null;
        }
        index++;
        task.finished = end;
        filesys.taskChanged(uuid, task);
        onProgress?.call(end.toDouble());
        if (end == file.lengthSync() && res.data != null) {
          var node = FileSystemItem(
            filesys,
            FileItemModel.fromJson(res.data),
            this,
          );
          children.add(node);
          return node;
        }
      }
    }
    return exist!;
  }

  List<FileItemModel> get childrenData {
    return children.map((item) {
      return item.metadata;
    }).toList();
  }

  _formatKey({String subName = ''}) {
    if (metadata.key == '' && subName == '') {
      return '';
    }
    try {
      var keys = metadata.key != null ? [metadata.key] : [];
      if (subName.isNotEmpty) {
        keys.add(subName);
      }
      print('base64------------${base64.encode(utf8.encode(keys.join('/')))}');
      return base64.encode(utf8.encode(keys.join('/')));
    } catch (err) {
      return '';
    }
  }

  FileSystemItem _newItemForDes(
      IFileSystemItem source,
      IFileSystemItem destination,
      ) {
    final node = FileSystemItem(
      filesys,
      FileItemModel(
        name: source.metadata.name,
        dateCreated: DateTime.now(),
        dateModified: DateTime.now(),
        size: source.metadata.size,
        shareLink: source.metadata.shareLink,
        extension: source.metadata.extension,
        thumbnail: source.metadata.thumbnail,
        key: '${destination.metadata.key}/${source.metadata.name}',
        isDirectory: source.metadata.isDirectory,
        contentType: source.metadata.contentType,
        hasSubDirectories: source.metadata.hasSubDirectories,
      ),
      destination,
    );
    for (final item in source.children) {
      node.children.add(_newItemForDes(item, node));
    }
    return node;
  }

}