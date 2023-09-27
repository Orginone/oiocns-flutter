import 'package:flutter/material.dart';
import 'package:flutter/src/material/popup_menu.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/chat/message/msgchat.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/target/base/belong.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/thing/fileinfo.dart';
import 'package:orginone/main.dart';

abstract class ICohort extends ITarget {}

class Cohort extends Target implements ICohort {
  Cohort(IBelong space, XTarget metadata)
      : super(metadata, [metadata.belong?.name ?? '', metadata.typeName!],
            space: space) {
    speciesTypes.add(SpeciesType.market);
  }

  @override
  // TODO: implement chats
  List<IMsgChat> get chats => [this];

  @override
  Future<void> deepLoad(
      {bool reload = false, bool reloadContent = false}) async {
    await Future.wait([
      loadMembers(reload: reload),
      directory.loadContent(reload: reloadContent)
    ]);
  }

  @override
  Future<bool> delete() async {
    final res = await kernel.deleteTarget(IdReq(id: metadata.id!));
    if (res.success) {
      space.cohorts.removeWhere((i) => i == this);
    }
    return res.success;
  }

  @override
  Future<bool> exit() async {
    if (metadata.belongId != space.metadata.id) {
      if (await removeMembers([space.user.metadata])) {
        space.cohorts.removeWhere((i) => i == this);
        return true;
      }
    }
    return false;
  }

  @override
  // TODO: implement subTarget
  List<ITarget> get subTarget => [];

  @override
  // TODO: implement targets
  List<ITarget> get targets => [this];

  @override
  // TODO: implement popupMenuItem
  List<PopupMenuItem> get popupMenuItem {
    List<PopupMenuKey> key = [];
    if (hasRelationAuth()) {
      key.addAll([...createPopupMenuKey, PopupMenuKey.updateInfo]);
    }
    key.addAll(defaultPopupMenuKey);

    return key
        .map((e) => PopupMenuItem(
              value: e,
              child: Text(e.label),
            ))
        .toList();
  }

  @override
  bool isLoaded = false;

  @override
  Future<bool> teamChangedNotity(XTarget target) async {
    return await pullMembers([target]);
  }

  @override
  List<IFileInfo<XEntity>> content(int mode) {
    return [];
  }

  @override
  // TODO: implement locationKey
  String get locationKey => '';
}
