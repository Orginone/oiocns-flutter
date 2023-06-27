

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
  late List<IIdentity> identitys;

  /// 加载用户设立的身份(角色)对象
  Future<List<IIdentity>> loadIdentitys({bool reload = false});

  /// 用户拉入新身份(角色)
  Future<bool> pullIdentitys(List<IIdentity> identitys);

  /// 用户移除身份(角色)
  Future<bool> removeIdentitys(List<IIdentity> identitys);
}

class Station extends Team implements IStation {
  Station(XTarget metadata,this.company):super(metadata,[metadata.belong?.name ?? '', '${metadata.typeName}群'],space: company){
    identitys = [];
    directory = company.directory;
  }

  @override
  late ICompany company;

  @override
  late List<IIdentity> identitys;

  @override
  // TODO: implement chats
  List<IMsgChat> get chats => [this];

  @override
  Future<ITeam?> createTarget(TargetModel data) async{
    return null;
  }

  @override
  Future<void> deepLoad({bool reload = false,bool reloadContent = false}) async{
    await loadMembers(reload: reload);
    await directory.loadContent(reload: reloadContent);
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
  Future<List<IIdentity>> loadIdentitys({bool reload = false}) async{
    if (identitys.isEmpty || reload) {
      var res = await kernel.queryTeamIdentitys(IdReq(id: metadata.id!));
      if (res.success) {
        identitys = (res.data?.result ?? []).map((item) => Identity(space,item)).toList();
      }
    }
    return identitys;
  }

  @override
  Future<bool> pullIdentitys(List<IIdentity> identitys) async{
    identitys = identitys.where((i) {
      return identitys.where((m) => m.metadata.id == i.metadata.id).isEmpty;
    }).toList();
    if (identitys.isNotEmpty) {
      var res = await kernel.pullAnyToTeam(GiveModel( id: metadata.id!,
        subIds: identitys.map((i) => i.metadata.id??"").toList(),));
      if (res.success) {
        this.identitys.addAll(identitys);
      }
      return res.success;
    }
    return true;
  }

  @override
  Future<bool> removeIdentitys(List<IIdentity> identitys) async{
    for (var identity in identitys) {
      var res = await kernel.removeOrExitOfTeam(GainModel( id: metadata.id!,
        subId: identity.metadata.id??"",));
      if (res.success) {
        this.identitys.removeWhere((i) => i == this);
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

}