import 'package:flutter/src/material/popup_menu.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/target/base/belong.dart';
import 'package:orginone/dart/core/thing/directory.dart';
import 'package:orginone/dart/core/thing/file_info.dart';
import 'package:orginone/main.dart';

abstract class IIdentity extends IFileInfo<XIdentity>{
  /// 设置身份（角色）的用户
  late IBelong space;

  /// 数据实体
  late XIdentity metadata;

  /// 赋予身份（角色）的成员用户
  late List<XTarget> members;

  /// 加载成员用户实体
  Future<List<XTarget>> loadMembers({bool reload = false});

  /// 身份（角色）拉入新成员
  Future<bool> pullMembers(List<XTarget> members);

  /// 身份（角色）移除成员
  Future<bool> removeMembers(List<XTarget> members);

  /// 更新身份（角色）信息
  Future<bool> update(IdentityModel data);

  /// 删除身份（角色）
  Future<bool> delete();
}


class Identity implements IIdentity {

  Identity(this.space, this.metadata) {
    members = [];
    directory = space.directory;
  }

  @override
  late List<XTarget> members;

  @override
  late XIdentity metadata;

  @override
  late IBelong space;

  @override
  Future<bool> delete() async{
    final res = await kernel.deleteAuthority(IdReq(id: metadata.id!));
    if (res.success) {
      space.identitys.removeWhere((i) => i != this);
    }
    return res.success;
  }

  @override
  Future<List<XTarget>> loadMembers({bool reload = false}) async {
    if (members.isEmpty || reload == true) {
      final res = await kernel.queryIdentityTargets(IdReq(id: metadata.id!));
      if (res.success) {
        members = res.data?.result ?? [];
      }
    }
    return members;
  }

  @override
  Future<bool> pullMembers(List<XTarget> members) async {
    var filter = members.where((i) {
      return this.members
          .where((m) => m.id == i.id)
          .isEmpty;
    }).toList();
    if (filter.isNotEmpty) {
      final res = await kernel.giveIdentity(GiveModel(id: metadata.id!,
          subIds: members.map((i) => i.id!).toList()));
      if (res.success) {
        this.members.addAll(members);
      }
      return res.success;
    }
    return true;
  }

@override
Future<bool> removeMembers(List<XTarget> members)async {
  final res = await kernel.removeIdentity(GiveModel( id: metadata.id!,
    subIds: members.map((i) => i.id!).toList(),));
  if (res.success) {
    for (final member in members) {
      this.members = this.members.where((i) => i.id != member.id).toList();
    }
  }
  return true;
}

@override
Future<bool> update(IdentityModel data) async{
  data.id = metadata.id;
  data.shareId = metadata.shareId;
  data.name = data.name ?? metadata.name;
  data.code = data.code ?? metadata.code;
  data.authId = data.authId ?? metadata.authId;
  data.remark = data.remark ?? metadata.remark;
  final res = await kernel.updateIdentity(data);
  if (res.success && res.data?.id != null) {
    metadata = res.data!;
  }
  return res.success;
}

  @override
  late IDirectory directory;


  @override
  Future<bool> copy(IDirectory destination) {
    // TODO: implement copy
    throw UnimplementedError();
  }

  @override
  // TODO: implement isInherited
  bool get isInherited => false;

  @override
  Future<bool> loadContent({bool reload = false}) {
    // TODO: implement loadContent
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
  // TODO: implement belongId
  String get belongId => metadata.belongId!;

  @override
  // TODO: implement id
  String get id => metadata.id!;

  @override
  // TODO: implement popupMenuItem
  List<PopupMenuItem> get popupMenuItem => [];

}