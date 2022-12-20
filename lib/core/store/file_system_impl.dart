import 'dart:io';

import 'package:get/get.dart';
import 'package:orginone/api/hub/any_store.dart';
import 'package:orginone/api/kernelapi.dart';
import 'package:orginone/api/model.dart';
import 'package:orginone/config/constant.dart';
import 'package:orginone/core/store/i_file_system.dart';
import 'package:orginone/enumeration/bucket_operates.dart';
import 'package:orginone/util/encryption_util.dart';

class FileSystemItem implements IFileSystemItem {
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
      keys.add(subName);
    }
    return EncryptionUtil.encodeURLString(subName);
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
      name: name,
      shareLink: "${Constant.bucket}/load${target.shareLink}",
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
  Future<IFileSystemItem?> create(String name) {
    throw UnimplementedError();
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
  Future<bool> loadChildren(bool reload) {
    throw UnimplementedError();
  }

  @override
  Future<bool> move(IFileSystemItem destination) {
    throw UnimplementedError();
  }

  @override
  Future<bool> rename(String name) {
    throw UnimplementedError();
  }

  @override
  Future<IFileSystemItem?> upload({
    required String name,
    required File file,
    required Function(double) onProgress,
  }) {
    throw UnimplementedError();
  }
}
