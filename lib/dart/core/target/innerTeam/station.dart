import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/public/consts.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/dart/core/public/operates.dart';
import 'package:orginone/dart/core/target/base/team.dart';
import 'package:orginone/dart/core/target/team/company.dart';
import 'package:orginone/dart/core/thing/directory.dart';
import 'package:orginone/dart/core/thing/fileinfo.dart';
import 'package:orginone/main.dart';

import '../person.dart';

abstract class IStation extends ITeam {
  /// 设立岗位的单位
  late ICompany companyspace;

  /// 岗位下的角色
  late List<XIdentity> identitys;

  /// 加载用户设立的身份(角色)对象
  Future<List<XIdentity>> loadIdentitys({bool? reload = false});

  /// 用户拉入新身份(角色)
  Future<bool> pullIdentitys(List<XIdentity> identitys, {bool? notity});

  /// 用户移除身份(角色)
  Future<bool> removeIdentitys(List<XIdentity> identitys, {bool? notity});
}

class Station extends Team implements IStation {
  Station(XTarget metadata, ICompany space)
      : super([space.key], metadata, [space.id]) {
    companyspace = space;
    user = space.user;
    identitys = [];
    directory = companyspace.directory;
  }

  @override
  late ICompany companyspace;

  @override
  late IPerson user;

  @override
  late IDirectory directory;

  @override
  late List<XIdentity> identitys;

  late bool _identityLoaded = false;

  // @override
  // // TODO: implement chats
  // List<IMsgChat> get chats => [this];

  @override
  Future<List<XIdentity>> loadIdentitys({bool? reload = false}) async {
    if (!_identityLoaded || reload!) {
      var res = await kernel.queryTeamIdentitys(IdPageModel(
        id: metadata.id,
        page: pageAll,
      ));
      if (res.success) {
        _identityLoaded = true;
        identitys = (res.data?.result ?? []);
      }
    }
    return identitys;
  }

  @override
  Future<bool> pullIdentitys(List<XIdentity> identitys,
      {bool? notity = false}) async {
    identitys = identitys
        .where((i) => this.identitys.every((a) => a.id != i.id))
        .toList();
    if (identitys.isNotEmpty) {
      if (!notity!) {
        final res = await kernel.pullAnyToTeam(GiveModel(
          id: id,
          subIds: identitys.map((i) => i.id).toList(),
        ));
        if (!res.success) return false;
        identitys = identitys.where((a) => res.data!.contains(a.id)).toList();
        identitys
            .forEach((a) async => await _sendTargetNotity(OperateType.add, a));
      }
      if (members.any((a) => a.id == userId)) {
        user.giveIdentity(
          identitys,
          identity: id,
        );
      }
      this.identitys.addAll(identitys);
    }
    return true;
  }

  @override
  Future<bool> removeIdentitys(List<XIdentity> identitys,
      {bool? notity = false}) async {
    identitys = identitys
        .where((i) => this.identitys.any((a) => a.id == i.id))
        .toList();
    if (identitys.isNotEmpty) {
      for (final identity in identitys) {
        if (!notity!) {
          final res = await kernel.removeOrExitOfTeam(GainModel(
            id: id,
            subId: identity.id,
          ));
          if (!res.success) return false;
          _sendTargetNotity(OperateType.remove, identity);
        }
        companyspace.user.removeGivedIdentity(
          identitys.map((a) => a.id).toList(),
          teamId: id,
        );
        this.identitys =
            this.identitys.where((i) => i.id != identity.id).toList();
      }
    }
    return true;
  }

  @override
  Future<bool> delete({bool? notity = false}) async {
    final success = await super.delete(notity: notity);
    if (success) {
      companyspace.stations =
          companyspace.stations.where((i) => i.key != key).toList();
      companyspace.user.removeGivedIdentity(
        identitys.map((e) => e.id).toList(),
        teamId: id,
      );
    }
    return success;
  }

  @override
  Future<void> deepLoad({bool? reload = false}) async {
    await Future.wait([
      loadIdentitys(reload: reload),
      loadMembers(reload: reload),
    ]);
  }

  @override
  Future<ITeam?> createTarget(TargetModel data) async {
    return null;
  }

  @override
  List<OperateModel> operates({int? mode}) {
    var operates = super.operates();
    if (hasRelationAuth()) {
      operates.insert(0, TeamOperates.pullIdentity as OperateModel);
    }
    return operates;
  }

  @override
  Future<bool> pullMembers(List<XTarget> members, {bool? notity}) async {
    if (await super.pullMembers(members, notity: notity)) {
      if (members.where((a) => a.id == userId).toList() != []) {
        user.giveIdentity(identitys, identity: id);
      }
      return true;
    }
    return false;
  }

  @override
  Future<bool> removeMembers(List<XTarget> members, {bool? notity}) async {
    if (await super.removeMembers(members, notity: notity)) {
      if (members.where((a) => a.id == userId).toList() != []) {
        user.removeGivedIdentity(
          identitys.map((e) => e.id).toList(),
          teamId: id,
        );
      }
      return true;
    }
    return false;
  }

  Future<bool> _sendTargetNotity(
    OperateType operate,
    XIdentity identity, {
    String? targetId,
    bool? ignoreSelf,
    bool? onlyTarget,
    bool? onlineOnly = true,
  }) async {
    var res = await kernel.dataNotify(DataNotityType(
      data: {
        'operate': operate as String,
        'station': metadata,
        'identity': identity,
        'operater': user.metadata,
      },
      targetId: targetId ?? id,
      ignoreSelf: ignoreSelf == true,
      flag: 'identity',
      relations: relations,
      belongId: belongId,
      onlyTarget: onlyTarget == true,
      onlineOnly: onlineOnly!,
      subTargetId: null,
    ));
    return res.success;
  }

  Future<void> _receiveIdentity(IdentityOperateModel data) async {
    var message = '';
    switch (data.operate) {
      case '删除':
        message = '${data.operater?.name}将身份【${data.identity?.name}】删除.';
        await removeIdentitys([data.identity!], notity: true);
        break;
      case '更新':
        message = '${data.operater?.name}将身份【${data.identity?.name}】信息更新.';
        var index = identitys
            .indexOf(identitys.firstWhere((a) => a.id == data.identity?.id));
        if (index > -1) {
          identitys[index] = data.identity!;
        }
        break;
      case '移除':
        message =
            '${data.operater?.name}移除岗位【$name】中的身份【${data.identity?.name}】.';
        await removeIdentitys([data.identity!], notity: true);
        break;
      case '新增':
        if (identitys.every((a) => a.id == data.identity?.id)) {
          message =
              '${data.operater?.name}向岗位【$name】添加身份【${data.identity?.name}】.';
          await pullIdentitys([data.identity!], notity: true);
        }
        break;
      default:
        return;
    }
    //日志
    // if (message.isNotEmpty) {
    //   if (data.operater?.id != this.user.id) {
    //     logger.info(message);
    //   }
    //   this.directory.structCallback();
    // }
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
