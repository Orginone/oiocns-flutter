

import 'package:flutter/src/material/popup_menu.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/chat/message/msgchat.dart';
import 'package:orginone/dart/core/target/base/team.dart';
import 'package:orginone/dart/core/target/identity/identity.dart';
import 'package:orginone/dart/core/target/team/company.dart';
import 'package:orginone/dart/core/thing/directory.dart';
import 'package:orginone/main.dart';

abstract class IStation implements ITeam {
  /// 设立岗位的单位
  late ICompany company;
  /// 岗位下的角色
  late List<XIdentity> identitys;

  /// 加载用户设立的身份(角色)对象
  Future<List<XIdentity>> loadIdentitys({bool reload = false});

  /// 用户拉入新身份(角色)
  Future<bool> pullIdentitys(List<XIdentity> identitys);

  /// 用户移除身份(角色)
  Future<bool> removeIdentitys(List<XIdentity> identitys);
}

class Station extends Team implements IStation {
  Station(XTarget metadata,this.company):super(metadata,[metadata.belong?.name ?? '', '${metadata.typeName}群'],space: company){
    identitys = [];
    directory = company.directory;
  }

  @override
  late ICompany company;

  @override
  late List<XIdentity> identitys;

  @override
  // TODO: implement chats
  List<IMsgChat> get chats => [this];

  @override
  Future<ITeam?> createTarget(TargetModel data) async{
    return null;
  }

  @override
  Future<void> deepLoad({bool reload = false,bool reloadContent = false}) async{
    await Future.wait([
      loadMembers(reload: reload),
      directory.loadContent(reload: reloadContent),
    ]);
  }

  @override
  Future<bool> delete() async{
    var res = await kernel.deleteTarget(IdReq(id: metadata.id!));
    if (res.success) {
      company.stations.removeWhere((i) => i == this);
    }
    return res.success;

  }

  @override
  Future<List<XIdentity>> loadIdentitys({bool reload = false}) async{
    if (identitys.isEmpty || reload) {
      var res = await kernel.queryTeamIdentitys(IdReq(id: metadata.id!));
      if (res.success) {
        identitys = (res.data?.result ?? []);
      }
    }
    return identitys;
  }

  @override
  Future<bool> pullIdentitys(List<XIdentity> identitys) async{
    identitys = identitys.where((i) => this.identitys.every((a) => a.id != i.id)).toList();
    if (identitys.isNotEmpty) {
      final res = await kernel.pullAnyToTeam(GiveModel( id: this.id,
        subIds: identitys.map((i) => i.id!).toList(),));
      if (!res.success) return false;
      // for (final identity in identitys) {
      //   createIdentityMsg(OperateType.Add, identity);
      // }
      this.identitys.addAll(identitys);
    }
    return true;
  }

  @override
  Future<bool> removeIdentitys(List<XIdentity> identitys) async{
    identitys = identitys.where((i) => this.identitys.any((a) => a.id == i.id)).toList();
    if (identitys.isNotEmpty) {
      for (final identity in identitys) {
        final res = await kernel.removeOrExitOfTeam(GainModel( id: id,
          subId: identity.id!,));
        if (!res.success) return false;
        // createIdentityMsg(OperateType.remove, identity);
        company.user.removeGivedIdentity(
          identitys.map((a) => a.id!).toList(),
          id,
        );
        this.identitys.removeWhere((i) => i.id == identity.id);
      }
    }
    return true;
  }

  @override
  late IDirectory directory;

  @override
  // TODO: implement popupMenuItem
  List<PopupMenuItem> get popupMenuItem => [];

  @override
  bool isLoaded = false;

  @override
  Future<bool> teamChangedNotity(XTarget target) async{
    return await pullMembers([target]);
  }

}