import 'dart:io';

import 'package:get/get.dart';
import 'package:orginone/api/hub/any_store.dart';
import 'package:orginone/api/kernelapi.dart';
import 'package:orginone/api/model.dart';
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

  FileSystemItem({
    required String key,
    required String name,
    required FileItemModel target,
    IFileSystemItem? parent,
    List<IFileSystemItem> children = const [],
  })  : _key = key,
        _name = name,
        _target = target,
        _parent = parent,
        _children = children.obs;

  String _formatKey({String subName = ""}) {
    var keys = [target.key];
    if (subName.isNotEmpty) {
      keys.add(subName);
    }
    return EncryptionUtil.encodeURLString(subName);
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
    }
    return false;
  }

  @override
  Future<IFileSystemItem?> create(String name) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<bool> delete() {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<void> download(String path, Function(double p1) onProgress) {
    // TODO: implement download
    throw UnimplementedError();
  }

  @override
  // TODO: implement key
  String get key => throw UnimplementedError();

  @override
  Future<bool> loadChildren(bool reload) {
    // TODO: implement loadChildren
    throw UnimplementedError();
  }

  @override
  Future<bool> move(IFileSystemItem destination) {
    // TODO: implement move
    throw UnimplementedError();
  }

  @override
  // TODO: implement name
  String get name => throw UnimplementedError();

  @override
  // TODO: implement parent
  IFileSystemItem? get parent => throw UnimplementedError();

  @override
  Future<bool> rename(String name) {
    // TODO: implement rename
    throw UnimplementedError();
  }

  @override
  FileItemShare shareInfo() {
    // TODO: implement shareInfo
    throw UnimplementedError();
  }

  @override
  // TODO: implement target
  FileItemModel get target => throw UnimplementedError();

  @override
  Future<IFileSystemItem?> upload({
    required String name,
    required File file,
    required Function(double) onProgress,
  }) {
    // TODO: implement upload
    throw UnimplementedError();
  }
}
