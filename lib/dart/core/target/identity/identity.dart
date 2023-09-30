import 'package:flutter/src/material/popup_menu.dart';
import 'package:orginone/dart/core/public/entity.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/dart/core/public/operates.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/thing/directory.dart';
import 'package:orginone/dart/core/thing/fileinfo.dart';
import 'package:orginone/main.dart';

abstract class IIdentity extends IFileInfo<XIdentity> {
  /// 设置身份（角色）的用户
  late ITarget current;

  /// 赋予身份（角色）的成员用户
  late List<XTarget> members;

  /// 加载成员用户实体
  Future<List<XTarget>> loadMembers({bool? reload = false});

  /// 身份（角色）拉入新成员
  Future<bool> pullMembers(List<XTarget> members, {bool? notity});

  /// 身份（角色）移除成员
  Future<bool> removeMembers(List<XTarget> members, {bool? notity});

  /// 更新身份（角色）信息
  Future<bool> update(IdentityModel data);

  /// 删除身份（角色）
  @override
  Future<bool> delete({bool? notity});
}

class Identity extends Entity<XIdentity> implements IIdentity {
  @override
  late List<XTarget> members;

  @override
  late ITarget current;
  @override
  late bool isInherited;
  @override
  late IDirectory directory;

  final bool _memberLoade = false;

  Identity(XIdentity _metadata, ITarget current)
      : super(
          _metadata,
        ) {
    typeName = '角色';
    isInherited = false;
    members = [];
    directory = current.directory;
  }

  @override
  Future<bool> rename(String name) async {
    return await update(IdentityModel(
      id: metadata.id,
      name: name,
      code: metadata.code,
      authId: metadata.authId,
      shareId: metadata.shareId,
      remark: metadata.remark,
    ));
  }

  @override
  Future<List<XTarget>> loadMembers({bool? reload = false}) async {
    if (members.isEmpty || reload == true) {
      final res = await kernel.queryIdentityTargets(IdReq(
        id: id,
        // page: pageAll,
      ));
      if (res.success) {
        members = res.data?.result ?? [];
      }
    }
    return members;
  }

  @override
  Future<bool> copy(IDirectory destination) {
    // TODO: implement copy
    throw UnimplementedError();
  }

  @override
  Future<bool> move(IDirectory destination) {
    // TODO: implement move
    throw UnimplementedError();
  }

  @override
  Future<bool> pullMembers(List<XTarget> members,
      {bool? notity = false}) async {
    var filter = members.where((i) {
      return this.members.where((m) => m.id == i.id).isEmpty;
    }).toList();
    if (!notity!) {
      final res = await kernel.giveIdentity(GiveModel(
          id: metadata.id, subIds: members.map((i) => i.id).toList()));
      if (res.success) {
        return false;
      }
      for (var a in members) {
        _sendIdentityChangeMsg(OperateType.add, subTarget: a);
      }
    }
    this.members.addAll(members);
    if (members.where((a) => a.id == userId).isNotEmpty) {
      current.user.giveIdentity([metadata]);
    }
    return true;
  }

  @override
  Future<bool> removeMembers(List<XTarget> members,
      {bool? notity = false}) async {
    members = members
        .where((i) => members.where((m) => m.id == i.id).isNotEmpty)
        .toList();
    if (members.isNotEmpty) {
      if (!notity!) {
        final res = await kernel.removeIdentity(GiveModel(
          id: metadata.id,
          subIds: members.map((i) => i.id).toList(),
        ));
        if (!res.success) return false;
        for (var i in members) {
          _sendIdentityChangeMsg(OperateType.remove, subTarget: i);
        }
      }
      if (members.where((a) => a.id == userId).isNotEmpty) {
        current.user.removeGivedIdentity([id]);
      }
      this.members = this
          .members
          .where((i) => members.every((s) => s.id != i.id))
          .toList();
    }
    return true;
  }

  @override
  Future<bool> update(IdentityModel data) async {
    data.id = id;
    data.shareId = metadata.shareId;
    data.name = data.name ?? metadata.name;
    data.code = data.code ?? metadata.code;
    data.authId = data.authId ?? metadata.authId;
    data.remark = data.remark ?? metadata.remark;
    final res = await kernel.updateIdentity(data);
    if (res.success && res.data?.id != null) {
      res.data?.typeName = '角色';
      setMetadata(res.data!);
      _sendIdentityChangeMsg(OperateType.update);
    }
    return res.success;
  }

  @override
  Future<bool> delete({bool? notity = false}) async {
    if (!notity!) {
      if (current.hasRelationAuth()) {
        _sendIdentityChangeMsg(OperateType.delete);
      }
      final res =
          await kernel.deleteIdentity(IdReqModel(id: id, typeName: typeName));
      if (!res.success) return false;
    }
    current.user.removeGivedIdentity([metadata.id]);
    current.identitys = current.identitys.where((i) => i.key != key).toList();
    return true;
  }

  @override
  List<OperateModel> operates({int? mode = 0}) {
    final List<OperateModel> operates = [];
    if (mode! % 2 == 0 && current.hasRelationAuth()) {
      operates.addAll(
          [EntityOperates.update, FileOperates.rename] as List<OperateModel>);
    }
    operates.addAll(super.operates(mode: 1));
    operates.sort((a, b) => (a.menus != null
        ? -10
        : b.menus != null
            ? 10
            : 0));
    return operates;
  }

  @override
  List<IFileInfo<XEntity>> content({int? mode}) {
    return [];
  }

  Future<void> _sendIdentityChangeMsg(OperateType operate,
      {XTarget? subTarget}) async {
    await current.sendIdentityChangeMsg({
      operate,
      subTarget,
      XIdentity(authId: metadata.authId, id: metadata.id),
      XTarget(
        thingId: current.user.metadata.thingId,
        idProofs: current.user.metadata.idProofs,
        identitys: current.user.metadata.identitys,
        things: current.user.metadata.things,
        relations: current.user.metadata.relations,
        team: current.user.metadata.team,
        attributes: current.user.metadata.attributes,
        authority: current.user.metadata.authority,
        relTeams: current.user.metadata.relTeams,
        givenIdentitys: current.user.metadata.givenIdentitys,
        targets: current.user.metadata.targets,
        thing: current.user.metadata.thing,
        id: current.user.metadata.id,
      ),
    });
  }

  @override
  // TODO: implement belongId
  String get belongId => metadata.belongId!;

  @override
  // TODO: implement id
  String get id => metadata.id;

  @override
  // TODO: implement popupMenuItem
  List<PopupMenuItem> get popupMenuItem => [];

  @override
  // TODO: implement locationKey
  String get locationKey => '';

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
