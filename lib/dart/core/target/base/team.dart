import 'dart:async';

import 'package:logging/logging.dart';
import 'package:orginone/dart/base/common/commands.dart';
import 'package:orginone/dart/base/index.dart';
import 'package:orginone/dart/core/chat/session.dart';
import 'package:orginone/dart/core/public/entity.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/consts.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/dart/core/public/operates.dart';
import 'package:orginone/dart/core/target/base/belong.dart';
import 'package:orginone/dart/core/thing/directory.dart';
import 'package:orginone/main.dart';

import '../person.dart';

abstract class ITeam implements IEntity<XTarget> {
  //当前用户
  late IPerson user;
  //加载归属组织
  late IBelong space;
  //当前目录
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

///团队基类实现
abstract class Team extends Entity<XTarget> implements ITeam {
  //构造函数
  Team(
    this.keys,
    this.metadata,
    this.relations, {
    this.memberTypes = mTypes,
  }) : super(metadata) {
    kernel.subscribe('${metadata.belongId}-${metadata.id}-target',
        [...keys, key], (data) => _receiveTarget(data as TargetOperateModel));
  }

  ///构造函数使用的参数
  final List<String> keys;
  @override
  final XTarget metadata;
  final List<String> relations;
  @override
  final List<TargetType> memberTypes;
  //其他参数
  @override
  List<XTarget> members = [];
  @override
  List<ISession> memberChats = [];
  @override
  late IDirectory directory;
  bool _memberLoaded = false;
  @override
  abstract IBelong space;
  @override
  abstract IPerson user;
  static const mTypes = [TargetType.person];
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
        for (var i in members) {
          updateMetadata(i);
        }
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
        for (var c in members) {
          sendTargetNotity(OperateType.add, sub: c, subTargetId: c.id);
        }
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
          notifySession(false, [member]); ////
        }
        this.members.removeWhere((i) => i.id == member.id);
        loadMemberChats([member], false);
      }
    }
    return true;
  }

  Future<XTarget?> create(TargetModel data) async {
    data.belongId = space.id;
    data.teamCode = data.teamCode ?? data.code;
    data.teamName = data.teamName ?? data.name;
    var res = await kernel.createTarget(data);
    if (res.success && res.data?.id != null) {
      await space.user.loadGivedIdentitys(reload: true);
      return res.data;
    }
    return null;
  }

  @override
  Future<bool> update(TargetModel data) async {
    data.id = id;
    data.typeName = typeName;
    data.belongId = metadata.belongId;
    data.name = data.name ?? name;
    data.code = data.code ?? code;
    data.icon = data.icon ?? metadata.icon;
    data.teamName = data.teamName ?? data.name;
    data.teamCode = data.teamCode ?? data.code;
    data.remark = data.remark ?? remark;
    var res = await kernel.updateTarget(data);
    if (res.success && res.data?.id != null) {
      setMetadata(res.data!);
      sendTargetNotity(OperateType.update);
    }
    return res.success;
  }

  @override
  Future<bool> delete({bool? notity = false}) async {
    if (!notity!) {
      if (hasRelationAuth() && id != belongId) {
        await sendTargetNotity(OperateType.delete);
      }
      final res = await kernel.deleteTarget(IdModel(metadata.id));
      notity = res.success;
    }
    if (notity) {
      kernel.unSubscribe(key);
    }
    return notity;
  }

  Future<bool> loadContent({bool reload = false}) async {
    await loadMembers(reload: reload);
    return true;
  }

  @override
  List<OperateModel> operates({int? mode}) {
    final operates = super.operates();
    if (hasRelationAuth()) {
      operates.insertAll(
          0,
          [EntityOperates.update, EntityOperates.delete]
              as Iterable<OperateModel>);
    }
    return operates;
  }

  @override
  Future<void> deepLoad({bool? reload});
  @override
  Future<ITeam?> createTarget(TargetModel data);

  void loadMemberChats(List<XTarget> members, bool isAdd) {
    memberChats = [];
  }

  @override
  bool hasRelationAuth() {
    return hasAuthoritys([OrgAuth.relationAuthId.label]);
  }

  @override
  bool hasAuthoritys(List<String> authIds) {
    authIds = space.superAuth?.loadParentAuthIds(authIds) ?? authIds;
    var orgIds = [metadata.belongId!, id];
    return user.authenticate(orgIds, authIds);
  }

  @override
  Future<bool> sendTargetNotity(OperateType operate,
      {XTarget? sub, String? subTargetId}) async {
    var res = await kernel.dataNotify(DataNotityType(
      data: {
        operate,
        metadata,
        sub,
        user.metadata,
      },
      targetId: id,
      ignoreSelf: false,
      flag: 'target',
      relations: relations,
      belongId: belongId,
      onlyTarget: false,
      onlineOnly: true,
      subTargetId: subTargetId,
    ));
    return res.success;
  }

  Future<void> _receiveTarget(TargetOperateModel data) async {
    var message = "";
    switch (data.operate) {
      case 'Add':
        if (data.subTarget != null) {
          if (id == data.target?.id) {
            if (memberTypes.contains(data.subTarget?.typeName as TargetType)) {
              message =
                  '${data.operater?.name}把${data.subTarget?.name}与${data.target?.name}建立关系.';
              await pullMembers([data.subTarget!], notity: true);
            } else {
              message = await _addSubTarget(data.subTarget!);
            }
          } else {
            message = await _addJoinTarget(data.target!);
          }
        }
        break;
      case 'Remove':
        if (data.subTarget != null) {
          if (id == data.target?.id && data.subTarget?.id != space.id) {
            if (memberTypes.contains(data.subTarget?.typeName as TargetType)) {
              message =
                  '${data.operater?.name}把${data.subTarget?.name}从${data.target?.name}移除.';
              await removeMembers([data.subTarget!], notity: true);
            }
          } else {
            message = await _removeJoinTarget(data.target!);
          }
        }
        break;
      case 'Delete':
        message = '${data.operater?.name}将${data.target?.name}删除.';
        delete(notity: true);
        break;
      case 'Update':
        message = '${data.operater?.name}将${data.target?.name}信息更新.';
        setMetadata(data.target!);
        break;
    }
    if (message.isNotEmpty) {
      if (data.operater?.id != user.id) {
        final Logger log = Logger('Team');
      }
      space.directory.structCallback();
      Command command = Command();
      command.emitterFlag();
    }
  }

  Future<String> _removeJoinTarget(XTarget _) async {
    await sleeps(Duration.zero);
    return '';
  }

  Future<String> _addSubTarget(XTarget _) async {
    await sleeps(Duration.zero);
    return '';
  }

  Future<String> _addJoinTarget(XTarget _) async {
    await sleeps(Duration.zero);
    return '';
  }

  Future<void> notifySession(bool _, List<XTarget> __) async {
    await sleeps(Duration.zero);
  }

  ///延时方法
  ///@param timeout 延时时长，单位ms
  Future<bool> sleeps(Duration timeout) async {
    return Future(() => Timer(timeout, () => true) as FutureOr<bool>);
  }
}
