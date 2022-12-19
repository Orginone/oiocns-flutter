import 'dart:io';

import 'package:orginone/api/model.dart';

abstract class IFileSystemItem {
  final String key;
  final String name;
  final FileItemModel target;
  final IFileSystemItem? parent;
  final List<IFileSystemItem> children;

  IFileSystemItem({
    required this.key,
    required this.name,
    required this.target,
    required this.parent,
    required this.children,
  });

  FileItemShare shareInfo();

  Future<IFileSystemItem?> create(String name);

  Future<bool> delete();

  Future<bool> rename(String name);

  Future<bool> copy(IFileSystemItem destination);

  Future<bool> move(IFileSystemItem destination);

  Future<bool> loadChildren(bool reload);

  Future<IFileSystemItem?> upload({
    required String name,
    required File file,
    required Function(double) onProgress,
  });

  Future<void> download(String path, Function(double) onProgress);
}
