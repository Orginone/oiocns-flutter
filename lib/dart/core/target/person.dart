import 'package:flutter/cupertino.dart';
import 'package:flutter/src/material/popup_menu.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/common/entity.dart';
import 'package:orginone/dart/base/index.dart';
import 'package:orginone/dart/core/chat/message/msgchat.dart';
import 'package:orginone/dart/core/consts.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/target/base/team.dart';
import 'package:orginone/dart/core/target/out_team/cohort.dart';
import 'package:orginone/dart/core/target/team/company.dart';
import 'package:orginone/dart/core/thing/file_info.dart';
import 'package:orginone/main.dart';
import 'package:orginone/util/local_store.dart';

import '../../base/model.dart';
import '../../base/schema.dart';
import '../public/enums.dart';
import '../public/objects.dart';
import '../public/entity.dart';
import 'base/belong.dart';
import 'team/hospital.dart';
import 'team/university.dart';

abstract class IPerson extends IBelong {
  //加入/管理的单位
  late RxList<ICompany> companys;
  //赋予人的身份(角色)实体
  late List<XIdProof> givedIdentitys;
  //用户缓存对象
  late XObject<Xbase> cacheObj;
  //拷贝的文件
  late Map<String, IFileInfo<XEntity>> copyFiles;
  //根据ID查询共享信息
  Future<ShareIcon> findShareById(String id);
  //根据Id查询共享信息
  Future<XEntity?> findEntityAsync(String id);
  //判断是否拥有某些用户的权限
  bool authenticate(List<String> orgIds, List<String> authIds);
  // 加载赋予人的身份(角色)实体
  Future<List<XIdProof>> loadGivedIdentitys({bool reload = false});
  //赋予身份
  void giveIdentitys(List<XIdentity> identitus, {String? identity});
  //移除赋予人的身份（角色）实体
  void removeGivedIdentity(List<String> identityIds, [String? teamId]);
  // //加载单位
  // Future<List<ICompany>> loadCompanys({bool reload = false}); /////
  //创建单位
  Future<ICompany?> createCompany(TargetModel data);
  //搜索用户
  Future<List<XTarget>> searchTargets(String filter, List<String> typeNames);
}

//人员类型实现
class Person extends Belong implements IPerson {
  @override
  late RxList<ICompany> companys;
  @override
  late List<XIdProof> givedIdentitys;
  @override
  late XObject<Xbase> cacheObj;
  @override
  late Map<String, IFileInfo<XEntity>> copyFiles;
  final bool _cohortloaded = false;
  bool _givedIdentityLoaded = false;

  Person(XTarget _metadata, XObject<Xbase> cacheObj)
      : super(_metadata, [], null) {
    cacheObj = XObject(_metadata, 'target-cache', [], [key]);
    copyFiles = {};
    companys = <ICompany>[].obs;
    givedIdentitys = [];
  }

  @override
  Future<List<XIdProof>> loadGivedIdentitys({bool reload = false}) async {
    if (givedIdentitys.isEmpty || reload) {
      var res = await kernel.queryGivedIdentitys();
      if (res.success) {
        _givedIdentityLoaded = true;
        givedIdentitys = res.data?.result ?? [];
      }
    }
    return givedIdentitys;
  }

  @override
  void giveIdentity(List<XIdentity> identitys, {String teamId = ''}) {
    for (identity of identitys) {
      if (
        !givedIdentitys.some(
          (a) => a.identityId == identity.id && a.teamId == teamId,
        )
      ) {
        givedIdentitys.push({
          ...identity,
          identity: identity,
          teamId: teamId || '',
          identityId: identity.id,
          targetId: id,
          target: metadata,
        });
      }
    }
  }

  @override
  void removeGivedIdentity(List<String> identityIds, [String? teamId]) {
    var idProofs = givedIdentitys
        .where((a) => identityIds.contains(a.identityId))
        .toList();
    if (teamId != null) {
      idProofs = idProofs.where((a) => a.teamId == teamId).toList();
    } else {
      idProofs = idProofs.where((a) => a.teamId == null).toList();
    }
    givedIdentitys
        .removeWhere((a) => idProofs.every((i) => i.id != a.identity?.id));
  }

  @override
  Future<List<ICohort>> loadCohorts({bool reload = false}) async {
    if (cohorts.isEmpty || reload) {
      var res = await kernel.queryJoinedTargetById(GetJoinedModel(
        id: metadata.id,
        typeNames: [TargetType.cohort.label],
        page: PageRequest(offset: 0, limit: 9999, filter: ''),
      ));
      if (res.success) {
        cohorts.clear();
        res.data?.result?.forEach((element) {
          cohorts.add(Cohort(this, element));
        });
      }
    }
    return cohorts;
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
      res.data!.belong = metadata;
      var company = createCompanyForTarget(res.data!);
      companys.add(company);
      await company.pullMembers([metadata]);
      return company;
    }
    return null;
  }

  @override
  Future<IStorage?> createStorage(TargetModel data) async {
    data.typeName = TargetType.storage;
    var metadata = await create(data);
    if(metadata != null){
      var storage = Storage(metadata,[],this);
      await storage.deepLoad();
      storages.push(storage);
      await storage.pullMembers([user.metadata]);
      return storage;
    }
    return null;
  }

  @override
  Future<ITeam?> createTarget(TargetModel data) {
    switch (TargetType.getType(data.typeName)) {
      case TargetType.cohort:
        return createCohort(data);
      case TargetType.storage:
        return createStorage(data);
      default:
        return createCompany(data);
    }
  }

  @override
  bool authenticate(List<String> orgIds, List<String> authIds) {
    return givedIdentitys
        .where((element) => element.identity != null)
        .where((element) => orgIds.contains(element.identity!.shareId))
        .where((element) => authIds.contains(element.identity!.authId))
        .isNotEmpty;
  }

  @override
  Future<bool> pullMembers(List<XTarget> members)async{
    return await applyJoin(members);
  }

  @override
  Future<bool> applyJoin(List<XTarget> members) async {
    var filter = members.where((element) {
      return [TargetType.person, TargetType.cohort,TargetType.storage, ...companyTypes]
          .contains(TargetType.getType(element.typeName!));
    }).toList();
    for (var value in filter) {
      if (TargetType.getType(value.typeName!) == TargetType.person) {
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
  Future<List<XTarget>> searchTargets(
      String filter, List<String> typeNames) async {
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
  Future<bool> exit() async {
    // TODO: implement exit
    return false;
  }

  @override
  Future<bool> delete() async {
    if(notify){
      //TODO 退出
      return false;
    }else{
      await sendTargetNotity(OperateType.remove, metadata, id);
      var res = await kernel.deleteTarget(IdReq(id: metadata.id));
      return res.success;
    }
  }

  @override
  List<ITarget> get subTarget {
    return [];
  }

  @override
  // TODO: implement shareTarget
  List<ITarget> get shareTarget => [this, ...cohorts];

  @override
  List<ITarget> get parentTarget => [...cohorts,...companys];

  @override
  List<ITarget> get content({int? mode})=>[...cohorts,...storages];

  @override
  // TODO: implement chats
  List<IMsgChat> get chats {
    List<IMsgChat> chats = [this];
    chats.addAll(cohortChats);
    chats.addAll(memberChats);
    return chats;
  }

  @override
  // TODO: implement cohortChats
  List<ISession> get cohortChats {
    List<ISession> chats = [];
    var companyChatIds = <String>[];
    for (var company in companys) {
      for (var item in company.cohorts) {
        companyChatIds.add(item.chatdata.value.fullId);
      }
    }
    for (var value in cohorts) {
      if (!companyChatIds.contains(value.chatdata.value.fullId)) {
        chats.addAll(value.chats);
      }
    }
    for(var item in storages){
      chats.addAll(item.chats);
    }
    return chats;
  }

  
  @override
  // TODO: implement targets
  List<ITarget> get targets {
    List<ITarget> targets = [this,...storages];
    // for (var item in companys) {
    //   targets.addAll(item.targets);
    // }
    for (var item in cohorts) {
      targets.addAll(item.targets);
    }
    return targets;
  }

  @override
  Future<void> deepLoad({bool reload =false}) async {
    await cacheObj.all();
    await Future.wait([
      loadCohorts(reload: reload),
      loadMembers(reload: reload),
      loadSuperAuth(reload: reload),
      loadGivedIdentitys(reload: reload),
      //directory.loadDirectoryResource(reload:reload),////////thing文件夹中
    ]);
    for (var company in companys) {
      await company.deepLoad(reload: reload);
    }
    for (var cohort in cohorts) {
      await cohort.deepLoad(reload: reload);
    }
    for (var storage in storages) {
      await storage.deepLoad(reload: reload);
    }
    superAuth?.deepLoad(reload: reload);
  }
  ///操作类未实现
  // @override
  // List<OperateModel> operates() {
  //   var operates = super.operates();
  //   operates.unshift(personJoins, targetOperates.NewCompany, targetOperates.NewStorage);
  //   return operates;
  // }

  @override
  Future<XEntity?> findEntityAsync(String id) async {
    Entity entity = Entity();///////
    var metadata = entity.findMetadata<XEntity>(id);
    var res = await kernel.queryEntityById(IdReq(id: id));
    if (res.success && res.data != null) {
      var shareIcon = res.data!.shareIcon();
      if (shareIcon != null) {
        ShareIdSet[id] = shareIcon;
      }
      return res.data;
    }
    return null;
  }

  @override
  Future<ShareIcon> findShareById(String id) async {
    var metadata =findMetadata<XEntity>(id);
    var share = ShareIcon(name: '未知', typeName: "未知");
    if (metadata == null) {
      findEntityAsync(id);
    }
    return ShareIcon(
      name: metadata?.name ?? '请稍后...', 
      typeName: metadata?.typeName ?? '未知',
      avatar: parseAvatar(metadata?.icon),
    );
  }

  @override
  Future<String> _removeJoinTarget(XTarget target) async {
    var find = [...cohorts,...companys,...storages].find();
    if(find){
      await find.delete(true);
      return '您已被从${target.name}移除';
    }
    return '';
  }

  @override
  Future<String> _addJoinTarget(XTarget target) async{
    switch (target.typeName) {
      case TargetType.cohort:
        if (cohorts.every((i) => i.id != target.id)) {
          const cohort = Cohort(target, this, target.id);
          await cohort.deepLoad();
          cohorts.push(cohort);
          return '您已成功加入到${target.name}.';
        }
        break;
      case TargetType.storage:
        if (storages.every((i) => i.id != target.id)) {
          const storage = Storage(target, [], this);
          await storage.deepLoad();
          storages.push(storage);
          return '您已成功加入到${target.name}.';
        }
        break;
      default:
        if (companyTypes.contains(target.typeName as TargetType)) {
          if (companys.every((i) => i.id != target.id)) {
            const company = createCompany(target, this);
            await company.deepLoad();
            companys.addAll(company);
            return '您已成功加入到${target.name}.';
          }
        }
        break;
    }
    return '';
  }



  // @override
  // // TODO: implement popupMenuItem
  // List<PopupMenuItem> get popupMenuItem {
  //   List<PopupMenuKey> key = [];
  //   if (hasRelationAuth()) {
  //     key.addAll([
  //       ...createPopupMenuKey,
  //       PopupMenuKey.createCohort,
  //       PopupMenuKey.createCompany,
  //       PopupMenuKey.updateInfo
  //     ]);
  //   }
  //   key.addAll(defaultPopupMenuKey);

  //   return key
  //       .map((e) => PopupMenuItem(
  //             value: e,
  //             child: Text(e.label),
  //           ))
  //       .toList();
  // }
}
