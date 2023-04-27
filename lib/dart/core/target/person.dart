import 'package:get/get.dart';
import 'package:orginone/dart/core/market/model.dart';
import 'package:orginone/dart/core/store/filesys.dart';
import 'package:orginone/dart/core/store/ifilesys.dart';
import 'package:orginone/dart/core/target/chat/chat.dart';
import 'package:orginone/dart/core/target/chat/ichat.dart';
import 'package:orginone/dart/core/target/todo/work.dart';
import 'package:orginone/dart/core/target/university.dart';
import 'package:orginone/dart/core/thing/dict.dart';
import '../../base/common/uint.dart';
import '../../base/model.dart';
import '../../base/schema.dart';
import '../enum.dart';
import 'authority/authority.dart';
import 'authority/iauthority.dart';
import 'cohort.dart';
import 'company.dart';
import 'hospital.dart';
import 'itarget.dart';
import 'mbase.dart';

class Person extends MarketTarget implements IPerson {
  @override
  late List<ICohort> cohorts;

  @override
  late RxList<ICompany> joinedCompany;

  @override
  set spaceData(SpaceType _) {}

  @override
  late List<IMarket> joinedMarkets;

  @override
  late List<IProduct> ownProducts;

  @override
  late List<IMarket> publicMarkets;

  @override
  late IAuthority? spaceAuthorityTree;

  @override
  late IObjectItem? home;

  @override
  late List<IChat> memberChats = <IChat>[].obs;

  @override
  late Dict dict;

  @override
  late List<XTarget> members;

  @override
  late IFileSystemItem root;

  @override
  late IWork work;

  Person(XTarget target) : super(target, null, target.id) {
    work = Work();
    super.searchTargetType = [
      TargetType.cohort,
      TargetType.person,
      ...companyTypes,
    ];
    subTeamTypes = [];
    joinTargetType = [
      TargetType.person,
      TargetType.cohort,
      ...companyTypes,
    ];
    dict = Dict(target.id);
    createTargetType = [TargetType.cohort, ...companyTypes];
    extendTargetType = [TargetType.cohort, TargetType.person];
    joinedCompany = <ICompany>[].obs;
    cohorts = [];
    Future.delayed(const Duration(milliseconds: 200), () async {
      // home = await root.create('主目录');
    });
    members = [];
    memberChats = <IChat>[].obs;
    root = getFileSysItemRoot(target.id);
  }

  @override
  Future<List<ITarget>> loadSubTeam({bool reload = false}) async {
    return [];
  }

  @override
  SpaceType get spaceData {
    final res = SpaceType();
    res.id = id;
    res.name = "个人空间";
    res.share = shareInfo;
    res.typeName = target.typeName as TargetType;
    return res;
  }

  @override
  Future<IAuthority?> loadSpaceAuthorityTree([bool reload = false]) async {
    if (!reload && spaceAuthorityTree != null) {
      return spaceAuthorityTree;
    }
    final res = await kernel.queryAuthorityTree(IdSpaceReq(
      id: '0',
      spaceId: id,
      page: PageRequest(
        offset: 0,
        filter: '',
        limit: Constants.maxUint16,
      ),
    ));
    if (res.success) {
      authorityTree = Authority(res.data!, this, userId);
    }
    return authorityTree;
  }

  @override
  Future<ITarget?> create(TargetModel data) async {
    switch (TargetType.getType(data.typeName)) {
      case TargetType.university:
      case TargetType.hospital:
      case TargetType.company:
        return _createCompany(data);
      case TargetType.cohort:
        return _createCohort(
            data.avatar, data.name, data.code, data.teamRemark);
      default:
        return null;
    }
  }

  @override
  Future<XTargetArray> searchCohort(code) async {
    return await searchTargetByName(code, [TargetType.cohort]);
  }

  @override
  Future<XTargetArray> searchPerson(code) async {
    return await searchTargetByName(code, [TargetType.person]);
  }

  @override
  Future<XTargetArray> searchCompany(code) async {
    return await searchTargetByName(code, companyTypes);
  }

  @override
  Future<List<ICohort>> getCohorts({bool reload = false}) async {
    if (!reload && cohorts.isNotEmpty) {
      return cohorts;
    }
    final res = await getjoinedTargets([TargetType.cohort], id);
    if (res.result != null) {
      cohorts = res.result
              ?.map((a) => Cohort(
                  a,
                  this,
                  userId,
                  () =>
                      {cohorts = cohorts.where((i) => i.id != a.id).toList()}))
              .toList() ??
          [];
    }
    return cohorts;
  }

  @override
  Future<List<ICompany>> getJoinedCompanys({bool reload = false}) async {
    if (!reload && joinedCompany.isNotEmpty) {
      return joinedCompany;
    }
    joinedCompany.clear();
    final res = await getjoinedTargets(companyTypes, id);
    if (res.result != null) {
      for (var a in res.result!) {
        late ICompany company;
        if (a.typeName == TargetType.university.label) {
          company = University(a, id);
        } else if (a.typeName == TargetType.university.label) {
          company = Hospital(a, id);
        } else {
          company = Company(a, id);
        }
        joinedCompany.add(company);
      }
    }
    return joinedCompany;
  }

  @override
  List<IChat> allChats() {
    var chats = [chat];
    for (var item in joinedCompany) {
      chats.addAll(item.allChats());
    }
    for (var item in cohorts) {
      chats.addAll(item.allChats());
    }
    if (authorityTree != null) {
      chats.addAll(authorityTree!.allChats());
    }
    chats.addAll(memberChats);
    return chats;
  }

  Future<ICohort?> _createCohort(avatar, name, code, remark) async {
    final res = await createTarget(TargetModel(
      code: code,
      name: name,
      avatar: avatar,
      teamCode: code,
      teamName: name,
      belongId: id,
      typeName: TargetType.cohort.label,
      teamRemark: remark,
    ));
    if (res.success && res.data != null) {
      final cohort = Cohort(
          res.data!,
          this,
          userId,
          () =>
              {cohorts = cohorts.where((i) => i.id != res.data!.id).toList()});
      cohorts.add(cohort);
      cohort.pullMember(target);
      return cohort;
    }
    return null;
  }

  Future<ICompany?> _createCompany(TargetModel data) async {
    data.belongId = id;
    if (!companyTypes.contains(data.typeName as TargetType)) {
      // logger.warn("您无法创建该类型单位!");
      return null;
    }
    // if (!validIsSocialCreditCode(data.code)) {
    //   logger.warn("请填写正确的代码!");
    //   return;
    // }
    final tres = await searchTargetByName(data.code, companyTypes);
    if (tres.result == null) {
      final res = await createTarget(data);
      if (res.success && res.data != null) {
        late ICompany company;
        if (res.success) {
          switch (data.typeName as TargetType) {
            case TargetType.university:
              company = University(res.data!, id);
              break;
            case TargetType.hospital:
              company = Hospital(res.data!, id);
              break;
            default:
              company = Company(res.data!, id);
              break;
          }
          joinedCompany.add(company);
          company.pullMember(target);
          return company;
        }
      }
    } else {
      // logger.warn(consts.IsExistError);
    }
    return null;
  }

  @override
  Future<IProduct?> createProduct(ProductModel data) async {
    final prod = await super.createProduct(data);
    if (prod != null) {
      usefulProduct.add(prod.prod);
      if (prod.prod.resource != null) {
        usefulResource[prod.prod.id!] = prod.prod.resource!;
      }
    }
    return prod;
  }

  @override
  Future<bool> deleteCohort(String id) async {
    final res = await kernel.deleteTarget(IdReqModel(
      id: id,
      typeName: TargetType.cohort.name,
      belongId: id,
    ));
    if (res.success) {
      cohorts = cohorts.where((a) => a.id != id).toList();
    }
    return res.success;
  }

  @override
  Future<bool> deleteCompany(String id) async {
    final res = await kernel.deleteTarget(IdReqModel(
      id: id,
      typeName: TargetType.company.name,
      belongId: id,
    ));
    if (res.success) {
      joinedCompany.removeWhere((a) => a.id != id);
    }
    return res.success;
  }

  @override
  Future<bool> applyJoinCohort(String id) async {
    final cohort = cohorts.firstWhere((cohort) => cohort.id == id);
    if (cohort.id == '') {
      return await applyJoin(id, TargetType.cohort);
    }
    // logger.warn(consts.IsJoinedError);
    return false;
  }

  @override
  Future<bool> applyJoinCompany(String id, TargetType typeName) async {
    final company = joinedCompany.firstWhere((company) => company.id == id);
    if (company.id == '') {
      return await applyJoin(id, typeName);
    }
    // logger.warn(consts.IsJoinedError);
    return false;
  }

  @override
  Future<bool> quitCohorts(String id) async {
    final res = await cancelJoinTeam(id);
    if (res.success) {
      cohorts = cohorts.where((cohort) => cohort.id != id).toList();
    }
    return res.success;
  }

  @override
  Future<bool> quitCompany(String id) async {
    final res = await kernel.exitAnyOfTeamAndBelong(ExitTeamModel(
      id: id,
      teamTypes: [
        TargetType.jobCohort.name,
        TargetType.department.name,
        TargetType.cohort.name,
        ...List<String>.from(companyTypes)
      ],
      targetId: id,
      targetType: TargetType.person.name,
    ));
    if (res.success) {
      joinedCompany.removeWhere((company) => company.id != id);
    }
    return res.success;
  }

  @override
  Future<List<XTarget>> loadMembers(PageRequest page) async {
    if (members.isEmpty) {
      final data = await super.loadMembers(page);
      if (data.isNotEmpty) {
        members.addAll(data);
        members = [];
        memberChats = [];
        for (var item in data) {
          members.add(item);
          memberChats.add(createChat(userId, id, item, ['好友']));
        }
      }
    }
    return members
        .where((a) =>
    a.code.contains(page.filter) || a.name.contains(page.filter))
        .skip(page.offset)
        .take(page.limit)
        .toList();
  }

  @override
  Future<bool> applyFriend(XTarget target) async {
    final joinedTarget = members.firstWhere((a) => a.id == target.id);
    if (joinedTarget.id == '') {
      if (await pullMember(target)) {
        return await applyJoin(target.id, TargetType.person);
      }
    }
    // logger.warn(consts.IsExistError);
    return false;
  }

  Future<bool> removeFriends(List<String> ids) async {
    if (await super.removeMembers(ids, type: TargetType.person.name)) {
      for (String id in ids) {
        await kernel.exitAnyOfTeam(ExitTeamModel(
          id: id,
          teamTypes: [TargetType.person.name],
          targetId: id,
          targetType: TargetType.person.name,
        ));
      }
      members.removeWhere((item) => !ids.contains(item.id));
      return true;
    }
    return false;
  }

  @override
  Future<bool> approvalFriendApply(XRelation relation, int status) async {
    final res = await approvalJoinApply(relation.id, status);
    if (status >= CommonStatus.approveStartStatus.value &&
        status < CommonStatus.rejectStartStatus.value &&
        res.success &&
        relation.target != null) {
      members.add(relation.target!);
    }
    return false;
  }

  @override
  Future<XRelationArray?> queryJoinApply() async {
    return (await kernel.queryJoinTeamApply(IDBelongReq(
      id: id,
      page: PageRequest(
        offset: 0,
        filter: "",
        limit: Constants.maxUint16,
      ),
    )))
        .data;
  }

  @override
  Future<XRelationArray?> queryJoinApproval() async {
    return (await kernel.queryTeamJoinApproval(IDBelongReq(
      id: id,
      page: PageRequest(
        offset: 0,
        filter: "",
        limit: Constants.maxUint16,
      ),
    )))
        .data;
  }

  @override
  Future<bool> cancelJoinApply(id) async {
    final res = await kernel.cancelJoinTeam(IdReqModel(
      id: id,
      typeName: TargetType.person.name,
      belongId: id,
    ));
    return res.success;
  }

  @override
  Future<bool> resetPassword(String password, String privateKey) async {
    return (await kernel.resetPassword(target.code, password, privateKey))
        .success;
  }
}
