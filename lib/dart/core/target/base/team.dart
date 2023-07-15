import 'dart:convert';

import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/chat/message/msgchat.dart';
import 'package:orginone/dart/core/consts.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/target/base/belong.dart';
import 'package:orginone/dart/core/thing/directory.dart';
import 'package:orginone/dart/core/thing/file_info.dart';
import 'package:orginone/main.dart';

abstract class ITeam implements IMsgChat, IFileInfo<XTarget>{
  //限定成员类型
  late List<TargetType> memberTypes;

  //用户相关的所有会话
  List<IMsgChat> get chats;

  //深加载
  Future<void> deepLoad({bool reload = false,bool reloadContent = false});

  //创建用户
  Future<ITeam?> createTarget(TargetModel data);

  //更新团队信息
  Future<bool> update(TargetModel data);

  //删除(注销)团队
  Future<bool> delete();

  //用户拉入新成员
  Future<bool> pullMembers(List<XTarget> members);

  //用户移除成员
  Future<bool> removeMembers(List<XTarget> members);

  //加载成员会话
  void loadMemberChats(List<XTarget> members, bool isAdd);

  bool hasAuthoritys(List<String> authIds);

  bool hasRelationAuth();

  void recvTarget(String operate, bool isChild, XTarget target);

  Future<bool> teamChangedNotity(XTarget target);
}


abstract class Team extends MsgChat implements ITeam{
  Team(this.metadata, List<String> labels, {IBelong? space})
      : super(
          metadata.belong!,
          metadata.id!,
          ShareIcon(
            name: metadata.name!,
            typeName: metadata.typeName!,
            avatar: FileItemShare.parseAvatar(metadata.icon),
          ),
          labels,
          metadata.remark ?? "",
          space,
        ) {
    memberTypes = [TargetType.person];
  }

  @override
  late List<TargetType> memberTypes;

  @override
  late XTarget metadata;

  bool _memberLoaded = false;

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
  // TODO: implement isInherited
  bool get isInherited => metadata.belongId != space.id;

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
    var data =TargetModel.fromJson(metadata.toJson());
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
  String get id => metadata.id!;

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
    var orgIds = [metadata.belongId!, metadata.id!];
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
  Future<List<XTarget>> loadMembers({bool reload = false}) async {
    if (!_memberLoaded || reload) {
      var res = await kernel.querySubTargetById(GetSubsModel(
        id: metadata.id!,
        subTypeNames: memberTypes.map((e) => e.label).toList(),
        page: PageRequest(offset: 0, limit: 9999, filter: ''),
      ));
      if (res.success) {
        _memberLoaded = true;
        members.value = res.data?.result ?? [];
        loadMemberChats(members, true);
      }
    }
    return members;
  }

  @override
  Future<bool> pullMembers(List<XTarget> members) async {
    var filterMembers = members
        .where((i) => memberTypes.contains(TargetType.getType(i.typeName!)))
        .toList();
    filterMembers = filterMembers.where((element) {
      return this.members.where((m) => m.id == element.id).isEmpty;
    }).toList();
    if (filterMembers.isNotEmpty) {
      var res = await kernel.pullAnyToTeam(GiveModel(
        id: metadata.id!,
        subIds: members.map((i) => i.id!).toList(),
      ));
      if (res.success) {
        this.members.addAll(filterMembers);
        this.members.refresh();
        for (var element in members) {
          createTargetMsg(OperateType.add, sub: element);
        }
        loadMemberChats(members, true);
      }
      return res.success;
    }
    return true;
  }

  @override
  Future<bool> removeMembers(List<XTarget> members) async {
    bool success = false;
    for (var member in members) {
      if (memberTypes.contains(TargetType.getType(member.typeName!))) {
        if (member.id == userId || hasRelationAuth()) {
          await createTargetMsg(OperateType.remove, sub: member);
        }
        var res = await kernel
            .removeOrExitOfTeam(GainModel(id: metadata.id!, subId: member.id!));
        success = res.success;
        if (res.success) {
          this.members.removeWhere((i) => i.id == member.id);
          loadMemberChats([member], false);
        }
      }
    }
    return success;
  }

  @override
  Future<bool> delete() async {
    if (hasRelationAuth()) {
      await createTargetMsg(OperateType.delete);
    }
    final res = await kernel.deleteTarget(IdReq(id: metadata.id!));
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
      targetId: sub != null && userId == metadata.id ? sub.id! : metadata.id!,
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
