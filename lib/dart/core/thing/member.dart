import 'package:flutter/src/material/popup_menu.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/thing/directory.dart';

import 'fileinfo.dart';

abstract class IMember extends IFileInfo<XTarget> {
  late bool isMember;

  String get fullId;
}

class Member extends FileInfo<XTarget> implements IMember {
  Member(super.metadata, super.directory) {
    isMember = true;
  }

  @override
  // TODO: implement fullId
  String get fullId => '${directory.belongId}-${metadata.id}';

  @override
  late bool isMember;

  @override
  Future<bool> copy(IDirectory destination) {
    // TODO: implement copy
    throw UnimplementedError();
  }

  @override
  Future<bool> delete() {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<bool> move(IDirectory destination) {
    // TODO: implement move
    throw UnimplementedError();
  }

  @override
  Future<bool> rename(String name) {
    // TODO: implement rename
    throw UnimplementedError();
  }

  @override
  // TODO: implement popupMenuItem
  List<PopupMenuItem> get popupMenuItem => [];

  @override
  bool isLoaded = false;

  @override
  List<IFileInfo<XEntity>> content(int mode) {
    return [];
  }

  @override
  // TODO: implement locationKey
  String get locationKey => '';
}
