import 'dart:convert';

import 'package:orginone/dart/base/index.dart';
import 'package:orginone/dart/core/public/entity.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/chat/message/msgchat.dart';
import 'package:orginone/dart/core/consts.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/dart/core/target/base/belong.dart';
import 'package:orginone/dart/core/thing/directory.dart';
import 'package:orginone/dart/core/thing/fileinfo.dart';
import 'package:orginone/main.dart';

import '../person.dart';

abstract class ITeam implements IEntity<XTarget> {
  //当前用户
  late IPerson user;
  //加载归属组织
  @override
  late IBelong space;
  //当前目录
  @override
  late IDirectory directory;
  //成员
  late List<XTarget> members;

  //限定成员类型
  late List<TargetType> memberTypes;
  //成员会话
  late List<ISession> memberChats;

  //深加载
  Future<void> deepLoad({bool? reload = false});
  //加载成员
  Future<List<XTarget>> loadMembers({bool? reload = false});


  //创建用户
  Future<ITeam?> createTarget(TargetModel data);

  //更新团队信息
  Future<bool> update(TargetModel data);

  //删除(注销)团队
  @override
  Future<bool> delete({bool? notity});

  //用户拉入新成员
  Future<bool> pullMembers(List<XTarget> members, {bool? notity});

  //用户移除成员
  Future<bool> removeMembers(List<XTarget> members, {bool? notity});

  //是否有管理关系的权限
  bool hasRelationAuth();

  //判断是否拥有某些权限
  bool hasAuthoritys(List<String> authIds);

  //发送组织变更消息
  Future<bool> sendTargetNotity(OperateType operate,
      {XTarget? sub, String? subTargetId});
}

abstract class Team extends MsgChat implements ITeam {
  Team(List<String> _keys, this.metadata, List<String> _relations,
      List<TargetType> _memberTypes)
      : super(metadata) {
    _memberTypes = [TargetType.person];
    memberTypes = _memberTypes;
    relations = _relations;
    kernel.subscribe('${metadata.belongId}-${metadata.id}-target',
        [..._keys, this.key], (data) => _receiveTarget(data));
  }

  late List<TargetType> memberTypes;
  @override
  late List<XTarget> members = [];
  @override
  List<ISession> memberChats = [];
  List<String> relations;
  IDirectory directory;
  bool _memberLoaded = false;

  @override
  bool get isInherited => metadata.belongId != space.id;

  @override
  Future<List<XTarget>> loadMembers({bool? reload = false}) async {
    if (!_memberLoaded || reload!) {
      var res = await kernel.querySubTargetById(GetSubsModel(
        id: metadata.id,
        subTypeNames: memberTypes.map((e) => e.label).toList(),
        page: pageAll(),
      ));
      if (res.success) {
        _memberLoaded = true;
        members = res.data?.result ?? [];
        members.forEach((i) => updateMetadata(i));
        loadMemberChats(members, true);
      }
    }
    return members;

  }

  @override
  Future<bool> pullMembers(List<XTarget> members,
      {bool? notity = false}) async {
    var filterMembers = members
        .where((i) => memberTypes.contains(TargetType.getType(i.typeName!)))
        .toList();
    members = filterMembers.where((element) {
      return this.members.where((m) => m.id == element.id).isEmpty;
    }).toList();
    if (members.isNotEmpty) {
      if (!notity!) {
        var res = await kernel.pullAnyToTeam(GiveModel(
          id: id,
          subIds: members.map((i) => i.id).toList(),
        ));

        if (!res.success) return false;
        members.forEach((c) =>
            sendTargetNotity(OperateType.add, sub: c, subTargetId: c.id));
      }
    }
    return true;
  }

  @override
  Future<bool> removeMembers(List<XTarget> members,
      {bool? notity = false}) async {
    var filterMembers = members
        .where((i) => memberTypes.contains(TargetType.getType(i.typeName!)))
        .toList();
    members = filterMembers.where((element) {
      return this.members.where((m) => m.id == element.id).isEmpty;
    }).toList();
    for (var member in members) {
      if (memberTypes.contains(TargetType.getType(member.typeName!))) {
        if (!notity!) {
          var res = await kernel
              .removeOrExitOfTeam(GainModel(id: id, subId: member.id));
          if (!res.success) return false;
          sendTargetNotity(OperateType.remove,
              sub: member, subTargetId: member.id);
          notifySesion(false, [member]); ////
        }
        this.members.removeWhere((i) => i.id == member.id);
        loadMemberChats([member], false);
      }
    }
    return true;
  }

  Future<XTarget?> create(TargetModel data) async {
    data.belongId = space.metadata.id;
    data.teamCode = data.teamCode ?? data.code;
    data.teamName = data.teamName ?? data.name;
    var res = await kernel.createTarget(data);
    if (res.success && res.data != null) {
      await space.user.loadGivedIdentitys(reload: true);
      return res.data;
    }
    return null;
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
  Future<bool> rename(String name) {
    var data = TargetModel.fromJson(metadata.toJson());
    data.name = name;
    data.teamCode = metadata.team?.code ?? metadata.code!;
    data.teamName = metadata.team?.name ?? metadata.name!;
    return update(data);
  }

  @override
  // TODO: implement belongId
  String get belongId => metadata.belongId!;

  @override
  // TODO: implement id
  String get id => metadata.id;

  @override
  void recvTarget(String operate, bool isChild, XTarget target) {
    if (isChild && memberTypes.contains(TargetType.getType(target.typeName!))) {
      switch (operate) {
        case 'Add':
          members.add(target);
          loadMemberChats([target], true);
          break;
        case 'Remove':
          members.removeWhere((a) => a.id == target.id);
          loadMemberChats([target], false);
          break;
        default:
          break;
      }
    }
  }

  @override
  bool hasAuthoritys(List<String> authIds) {
    authIds = space.superAuth?.loadParentAuthIds(authIds) ?? authIds;
    var orgIds = [metadata.belongId!, metadata.id];
    return space.user.authenticate(orgIds, authIds);
  }

  @override
  bool hasRelationAuth() {
    return hasAuthoritys([OrgAuth.relationAuthId.label]);
  }

  @override
  void loadMemberChats(List<XTarget> members, bool isAdd) {
    memberChats = [];
  }

  @override
  Future<bool> delete() async {
    if (hasRelationAuth()) {
      await createTargetMsg(OperateType.delete);
    }
    final res = await kernel.deleteTarget(IdReq(id: metadata.id));
    return res.success;
  }

  @override
  Future<bool> loadContent({bool reload = false}) async {
    await directory.loadContent(reload: reload);
    return true;
  }

  @override
  Future<bool> update(TargetModel data) async {
    data.id = metadata.id;
    data.typeName = metadata.typeName!;
    data.belongId = metadata.belongId;
    data.name = data.name ?? metadata.name;
    data.code = data.code ?? metadata.code;
    data.icon = data.icon ?? metadata.icon;
    data.teamName = data.teamName ?? data.name;
    data.teamCode = data.teamCode ?? data.code;
    data.remark = data.remark ?? metadata.remark;
    var res = await kernel.updateTarget(data);
    if (res.success && res.data != null) {
      metadata = res.data!;
      share.typeName = metadata.typeName!;
      share.name = metadata.name!;
      share.avatar = FileItemShare.parseAvatar(metadata.icon);
      createTargetMsg(OperateType.update);
    }
    return res.success;
  }

  Future<void> createTargetMsg(OperateType operate, {XTarget? sub}) async {
    await kernel.createTargetMsg(TargetMessageModel(
      targetId: sub != null && userId == metadata.id ? sub.id : metadata.id,
      excludeOperater: false,
      group: metadata.typeName == TargetType.group.label,
      data: jsonEncode({
        'operate': operate.label,
        'target': metadata,
        'subTarget': sub,
        'operater': space.user.metadata,
      }),
    ));
  }
}
