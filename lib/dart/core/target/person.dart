import 'package:orginone/dart/base/index.dart';
import 'package:orginone/dart/core/chat/activity.dart';
import 'package:orginone/dart/core/chat/session.dart';
import 'package:orginone/dart/core/public/consts.dart';
import 'package:orginone/dart/core/public/operates.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/target/base/team.dart';
import 'package:orginone/dart/core/target/outTeam/cohort.dart';
import 'package:orginone/dart/core/target/outTeam/storage.dart';
import 'package:orginone/dart/core/target/team/company.dart';
import 'package:orginone/dart/core/target/team/hospital.dart';
import 'package:orginone/dart/core/target/team/university.dart';
import 'package:orginone/dart/core/thing/fileinfo.dart';
import 'package:orginone/main.dart';

import '../../base/model.dart';
import '../../base/schema.dart';
import '../public/enums.dart';
import '../public/objects.dart';
import 'base/belong.dart';

abstract class IPerson extends IBelong {
  IPerson(super.metadata, super.relations, super.directory);
  //加入/管理的单位
  late List<ICompany> companys;
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
  void giveIdentity(List<XIdentity> identitys, {String? teamId});
  //移除赋予人的身份（角色）实体
  void removeGivedIdentity(List<String> identityIds, {String? teamId});
  // //加载单位
  // Future<List<ICompany>> loadCompanys({bool reload = false}); /////
  //创建单位
  Future<ICompany?> createCompany(TargetModel data);
  //搜索用户
  Future<List<XTarget>> searchTargets(String filter, List<String> typeNames);
}

//人员类型实现
class Person extends Belong implements IPerson {
  Person(this.metadata) : super(metadata, []) {
    cacheObj = XObject(metadata, 'target-cache', [], [key]);

    ///TODO:FriendsActivity类需创建
// friendsActivity = FriendsActivity(this);
  }
  @override
  final XTarget metadata;
  @override
  late List<ICompany> companys;
  late IActivity friendsActivity;
  @override
  late XObject<Xbase> cacheObj;
  @override
  late List<XIdProof> givedIdentitys;

  @override
  Map<String, IFileInfo<XEntity>> copyFiles = {};
  bool _cohortLoaded = false;
  bool _givedIdentityLoaded = false;
  @override
  Future<List<XIdProof>> loadGivedIdentitys({bool reload = false}) async {
    if (!_givedIdentityLoaded || reload) {
      var res = await kernel.queryGivedIdentitys();
      if (res.success) {
        _givedIdentityLoaded = true;
        givedIdentitys = res.data?.result ?? [];
      }
    }
    return givedIdentitys;
  }

  @override
  void giveIdentity(List<XIdentity> identitys, {String? teamId = ''}) {
    for (var identity in identitys) {
      if (!givedIdentitys.any(
        (a) => a.identityId == identity.id && a.teamId == teamId,
      )) {
        XIdProof xIdProof = XIdProof.fromJson(identity.toJson());
        xIdProof.identity = identity;
        xIdProof.teamId = teamId;
        xIdProof.identityId = identity.id;
        xIdProof.targetId = id;
        xIdProof.target = metadata;

        givedIdentitys.add(xIdProof);
      }
    }
  }

  @override
  void removeGivedIdentity(List<String> identityIds, {String? teamId}) {
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

  Future<List<ICohort>> loadCohorts({bool reload = false}) async {
    if (!_cohortLoaded || reload) {
      var res = await kernel.queryJoinedTargetById(GetJoinedModel(
        id: metadata.id,
        typeNames: [
          TargetType.cohort.label,
          TargetType.storage.label,
          TargetType.company.label,
          TargetType.hospital.label,
          TargetType.university.label,
        ],
        page: pageAll,
      ));
      if (res.success) {
        _cohortLoaded = true;
        cohorts = [];
        storages = [];
        companys = [];
        for (var i in res.data?.result ?? []) {
          switch (i.typeName) {
            case TargetType.cohort:
              cohorts.add(Cohort(i, this, i.id));
              break;
            case TargetType.storage:
              storages.add(Storage(i, [], this));
              break;
            default:
              companys.add(_createCompany(i, this));
          }
        }
      }
    }
    return cohorts;
  }

  Company _createCompany(XTarget metadata, IPerson user) {
    switch (TargetType.getType(metadata.typeName ?? '')) {
      case TargetType.hospital:
        return Hospital(metadata, user);
      case TargetType.university:
        return University(metadata, user);
      default:
        return Company(metadata, user);
    }
  }

  @override
  Future<ICompany?> createCompany(TargetModel data) async {
    if (!companyTypes.contains(TargetType.getType(metadata.typeName ?? ''))) {
      data.typeName = TargetType.company.label;
    }
    data.public = false;
    data.teamCode = data.teamCode ?? data.code;
    data.teamName = data.teamName ?? data.name;
    var res = await create(data);
    if (res != null) {
      var company = _createCompany(res, this);
      await company.deepLoad();
      companys.add(company);
      await company.pullMembers([metadata]);
      return company;
    }
    return null;
  }

  Future<IStorage?> createStorage(TargetModel data) async {
    data.typeName = TargetType.storage.label;
    var metadata = await create(data);
    if (metadata != null) {
      var storage = Storage(metadata, [], this);
      await storage.deepLoad();
      storages.add(storage);
      await storage.pullMembers(user == null ? [] : [user!.metadata]);
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
  Future<bool> pullMembers(List<XTarget> members, {bool? notity}) async {
    return await applyJoin(members);
  }

  @override
  Future<bool> applyJoin(List<XTarget> members) async {
    var filter = members.where((element) {
      return [
        TargetType.person,
        TargetType.cohort,
        TargetType.storage,
        ...companyTypes
      ].contains(TargetType.getType(element.typeName!));
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
    var res = await kernel.searchTargets(SearchModel(
      filter,
      typeNames,
      page: pageAll,
    ));
    if (res.success) {
      return res.data?.result ?? [];
    }
    return [];
  }

  @override
  Future<bool> exit() async {
    return false;
  }

  @override
  Future<bool> delete({bool? notity = false}) async {
    if (notity == null || !notity) {
      return false;
    } else {
      await sendTargetNotity(OperateType.remove,
          sub: metadata, subTargetId: id);
      var res = await kernel.deleteTarget(IdModel(metadata.id));
      return res.success;
    }
  }

  @override
  List<ITarget> get subTarget {
    return [];
  }

  @override
  List<ITarget> get shareTarget => [this, ...cohorts];

  @override
  List<ITarget> get parentTarget => [...cohorts, ...companys];

  @override
  List<ISession> get chats {
    List<ISession> chats = [session];
    chats.addAll(cohortChats);
    chats.addAll(memberChats);
    return chats;
  }

  @override
  List<ISession> get cohortChats {
    List<ISession> chats = [];
    var companyChatIds = <String>[];
    for (var company in companys) {
      for (var item in company.cohorts) {
        companyChatIds.add(item.session.chatdata.fullId);
      }
    }
    for (var value in cohorts) {
      if (!companyChatIds.contains(value.session.chatdata.fullId)) {
        chats.addAll(value.chats);
      }
    }
    for (var item in storages) {
      chats.addAll(item.chats);
    }
    return chats;
  }

  @override
  List<ITarget> get targets {
    List<ITarget> targets = [this, ...storages];

    for (var item in cohorts) {
      targets.addAll(item.targets);
    }
    return targets;
  }

  @override
  Future<void> deepLoad({bool? reload = false}) async {
    await cacheObj.all();
    await Future.wait([
      loadCohorts(reload: reload!),
      loadMembers(reload: reload),
      loadSuperAuth(reload: reload),
      loadGivedIdentitys(reload: reload),
      directory.loadDirectoryResource(reload: reload), ////////thing文件夹中
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
  @override
  List<OperateModel> operates({int? mode}) {
    var operates = super.operates();
    OperateModel.fromJson(PersonJoins().toJson());
    OperateModel.fromJson(TargetOperates.newCompany.toJson());
    OperateModel.fromJson(TargetOperates.newStorage.toJson());

    operates.insert(0, OperateModel.fromJson(PersonJoins().toJson()));
    operates.insert(
        0, OperateModel.fromJson(TargetOperates.newCompany.toJson()));
    operates.insert(
        0, OperateModel.fromJson(TargetOperates.newStorage.toJson()));

    return operates;
  }

  @override
  List<ITarget> content({int? mode}) => [...cohorts, ...storages];
  @override
  Future<XEntity?> findEntityAsync(String id) async {
////
    var metadata = findMetadata<XEntity>(id);
    if (metadata != null) return metadata;

    var res = await kernel.queryEntityById(IdModel(id));
    if (res.success && res.data != null) {
      updateMetadata(res.data!);
      return res.data;
    }
    return null;
  }

  @override
  Future<ShareIcon> findShareById(String id) async {
    var metadata = findMetadata<XEntity>(id);
    if (metadata == null) {
      findEntityAsync(id);
    }
    return ShareIcon(
      name: metadata?.name ?? '请稍后...',
      typeName: metadata?.typeName ?? '未知',
      avatar: parseAvatar(metadata?.icon),
    );
  }

  Future<String> _removeJoinTarget(XTarget target) async {
    var index = [...cohorts, ...companys, ...storages]
        .indexWhere((i) => i.id == target.id);
    var find = [...cohorts, ...companys, ...storages]
        .firstWhere((i) => i.id == target.id);
    if (index < 0) {
      await find.delete(notity: true);
      return '您已被从${target.name}移除';
    }
    return '';
  }

  @override
  Future<String> _addJoinTarget(XTarget target) async {
    switch (TargetType.getType(target.typeName ?? '')) {
      case TargetType.cohort:
        if (cohorts.every((i) => i.id != target.id)) {
          final cohort = Cohort(target, this, target.id);
          await cohort.deepLoad();
          cohorts.add(cohort);
          return '您已成功加入到${target.name}.';
        }
        break;
      case TargetType.storage:
        if (storages.every((i) => i.id != target.id)) {
          final storage = Storage(target, [], this);
          await storage.deepLoad();
          storages.add(storage);
          return '您已成功加入到${target.name}.';
        }
        break;
      default:
        if (companyTypes.contains(TargetType.getType(target.typeName ?? ''))) {
          if (companys.every((i) => i.id != target.id)) {
            final company = _createCompany(target, this);
            await company.deepLoad();
            companys.add(company);
            return '您已成功加入到${target.name}.';
          }
        }
        break;
    }
    return '';
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
