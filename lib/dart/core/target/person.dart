import 'package:get/get.dart';
import 'package:orginone/dart/core/chat/msgchat.dart';
import 'package:orginone/dart/core/consts.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/target/base/team.dart';
import 'package:orginone/dart/core/target/out_team/cohort.dart';
import 'package:orginone/dart/core/target/team/company.dart';
import 'package:orginone/dart/core/thing/app/application.dart';
import 'package:orginone/dart/core/thing/filesys/filesysItem.dart';
import 'package:orginone/main.dart';

import '../../base/model.dart';
import '../../base/schema.dart';
import '../enum.dart';
import 'base/belong.dart';
import 'team/hospital.dart';
import 'team/university.dart';

abstract class IPerson extends IBelong {
  //加入/管理的单位
  late RxList<ICompany> companys;


  //赋予人的身份(角色)实体
  late List<XIdentity> givedIdentitys;

  //根据ID查询共享信息
  Future<TargetShare> findShareById(String id);

  //判断是否拥有某些用户的权限
  bool authenticate(List<String> orgIds, List<String> authIds);

  // 加载赋予人的身份(角色)实体
  Future<List<XIdentity>> loadGivedIdentitys({bool reload = false});

  //加载单位
  Future<List<ICompany>> loadCompanys({bool reload = false});

  //创建单位
  Future<ICompany?> createCompany(TargetModel data);

  //搜索用户
  Future<List<XTarget>> searchTargets(String filter, List<String> typeNames);
}

class Person extends Belong implements IPerson {

  @override
  late RxList<ICompany> companys;

  @override
  late List<XIdentity> givedIdentitys;

  Person(XTarget metadata):super(metadata,['本人']){
    companys = <ICompany>[].obs;
    givedIdentitys = [];
    userId = metadata.id;
  }

  @override
  Future<bool> applyJoin(List<XTarget> members) async {
    var filter = members.where((element) {
      return [TargetType.person, TargetType.cohort, ...companyTypes]
          .contains(TargetType.getType(element.typeName));
    }).toList();
    for (var value in filter) {
      if (TargetType.getType(value.typeName) == TargetType.person) {
        await pullMembers([value]);
      }
      await kernel.applyJoinTeam(GainModel(
        id: value.id,
        subId: metadata.id,
      ));
    }
    return true;
  }

  @override
  bool authenticate(List<String> orgIds, List<String> authIds) {
    return givedIdentitys
        .where((element) =>
    orgIds.contains(element.shareId) && authIds.contains(element.authId))
        .isNotEmpty;
  }

  @override
  Future<ICompany?> createCompany(TargetModel data) async {
    if (!companyTypes.contains(TargetType.getType(data.typeName))) {
      data.typeName = TargetType.company.label;
    }
    data.public = false;
    data.teamCode = data.teamCode ?? data.code;
    data.teamName = data.teamName ?? data.name;
    var res = await kernel.createTarget(data);
    if (res.success && res.data != null) {
      var company = createCompanyForTarget(res.data!);
      companys.add(company);
      await company.pullMembers([metadata]);
      return company;
    }
  }

  @override
  Future<ITeam?> createTarget(TargetModel data) {
    switch (TargetType.getType(data.typeName)) {
      case TargetType.cohort:
        return createCohort(data);
      default:
        return createCompany(data);
    }
  }

  @override
  Future<TargetShare> findShareById(String id) async{
    var share = TargetShare(name: '未知', typeName: "未知");
    if (!ShareIdSet.containsKey(id)) {
      var res = await kernel
          .queryTargetById(IdArrayReq(ids: [id],
        page: PageRequest(offset: 0, limit: 9999, filter: ''),));

      if (res.success && res.data?.result != null) {
        res.data?.result?.forEach((item) {
          ShareIdSet[item.id] = TargetShare(name: item.name,
              typeName: item.typeName,
              avatar: FileItemShare.parseAvatar(item.icon));
        });
        share = ShareIdSet[id] ?? share;
      }
    }else{
      return ShareIdSet[id]!;
    }
    return share;
  }
    @override
    Future<List<ICompany>> loadCompanys({bool reload = false}) async {
      if (!reload && companys.isNotEmpty) {
        return companys;
      }
      companys.clear();
      final res = await kernel.queryJoinedTargetById(GetJoinedModel(
          id: metadata.id,
          typeNames: [
            TargetType.company.label,
            TargetType.hospital.label,
            TargetType.university.label
          ],
          page: PageRequest(offset: 0, limit: 9999, filter: '')));
      if (res.success) {
        res.data?.result?.forEach((element) {
          companys.add(createCompanyForTarget(element));
        });
      }
      return companys;
    }

    ICompany createCompanyForTarget(XTarget metadata) {
      switch (TargetType.getType(metadata.typeName)) {
        case TargetType.hospital:
          return Hospital(metadata, this);
        case TargetType.university:
          return University(metadata, this);
        default:
          return Company(metadata, this);
      }
    }

    @override
    Future<List<XIdentity>> loadGivedIdentitys({bool reload = false}) async{
      if (givedIdentitys.isEmpty || reload) {
        var res = await kernel.queryGivedIdentitys();
        if (res.success) {
          givedIdentitys = res.data?.result ?? [];
        }
      }
      return givedIdentitys;
    }

    @override
  Future<List<ICohort>> loadCohorts({bool reload = false}) async{
      if (cohorts.isEmpty || reload) {
        var res = await kernel.queryJoinedTargetById(GetJoinedModel(  id: metadata.id,
          typeNames: [TargetType.cohort.label],
          page: PageRequest(offset: 0, limit: 9999, filter: ''),));
        if (res.success) {
          res.data?.result?.forEach((element) {
            cohorts.add(Cohort(this,element));
          });
        }
      }
      return cohorts;
  }

    @override
    Future<List<XTarget>> searchTargets(String filter, List<String> typeNames) async{
      var res = await kernel.searchTargets(NameTypeModel(
        name: filter,
        typeNames: typeNames,
        page: PageRequest(offset: 0, limit: 9999, filter: ''),
      ));
      if (res.success) {
        return res.data?.result ?? [];
      }
      return [];
    }

    @override
  Future<bool> exit() async{
    // TODO: implement exit
    return false;
  }

  @override
  Future<bool> delete() async{
    var res = await kernel.deleteTarget(IdReq(id: metadata.id));
    return res.success;
  }

    @override
    List<ITarget> get parentTarget {
      return [this, ...cohorts];
    }

    @override
    List<ITarget> get subTarget {
      return [];
    }

    @override
  // TODO: implement chats
  List<IChat> get chats{
      List<IChat> chats = [this];
      for (var item in companys) {
      chats.addAll(item.chats);
      }
      chats.addAll(cohortChats);
      chats.addAll(memberChats);
      return chats;
  }


  @override
  // TODO: implement cohortChats
  List<IChat> get cohortChats{
    List<IChat> chats = [];
    for (var value in cohorts) {
      chats.addAll(value.chats);
    }
    if (superAuth!=null) {
      chats.addAll(superAuth!.chats);
    }
    return chats;
  }

  @override
  // TODO: implement workSpecies
  List<IApplication> get workSpecies{
    List<IApplication> items = (species.where((element) => element.metadata.typeName == SpeciesType.application.label).toList()) as List<IApplication>;
    for (var item in companys) {
      items.addAll(item.workSpecies);
    }
    for (var item in cohorts) {
      items.addAll(item.species.where(
            (a) => a.metadata.typeName == SpeciesType.workItem.label,
      ).toList() as List<IApplication>);
    }

    return items;
  }


  @override
  void loadMemberChats(List<XTarget> members, bool isAdd) {
    for (var member in members) {
      if(isAdd){
        memberChats.add(
          PersonMsgChat(
            metadata.id,
            metadata.id,
            member.id,
            TargetShare(name: member.name,
              typeName: member.typeName,
              avatar: FileItemShare.parseAvatar(member.icon),),
            ['好友'],
            member.remark??"",
          ),
        );
      }else{
        memberChats.value = memberChats.where((p0) => !(p0.belongId == member.id && p0.chatId == member.id)).toList();
      }
    }
    memberChats.refresh();
  }

  @override
  Future<void> deepLoad({bool reload = false}) async{
    await loadGivedIdentitys(reload: reload);
    await loadCompanys(reload: reload);
    await loadCohorts(reload: reload);
    await loadMembers(reload: reload);
    await loadSuperAuth(reload: reload);
    await loadSpecies(reload: reload);
    for (var company in companys) {
      await company.deepLoad(reload: reload);
    }

    for (var cohort in cohorts) {
      await cohort.deepLoad(reload: reload);
    }

    superAuth?.deepLoad(reload: reload);
  }

  @override
  // TODO: implement targets
  List<ITarget> get targets{
    List<ITarget> targets = [this];
    for (var item in companys) {
      targets.addAll(item.targets);
    }
    for (var item in cohorts) {
      targets.addAll(item.targets);
    }
    return targets;
  }

}
