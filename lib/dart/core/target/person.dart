import 'package:orginone/dart/core/target/university.dart';

import '../../base/common/uint.dart';
import '../../base/model.dart';
import '../../base/schema.dart';
import '../enum.dart';
import 'cohort.dart';
import 'company.dart';
import 'hospital.dart';
import 'itarget.dart';
import 'mbase.dart';

class Person extends MarketTarget implements IPerson {
  Person(XTarget target) : super(target) {
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
    createTargetType = [TargetType.cohort, ...companyTypes];
    extendTargetType = [TargetType.cohort, TargetType.person];
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
  Future<ITarget?> create(TargetModel data) async {
    switch (data.typeName as TargetType) {
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
      res.result?.map((a) => Cohort(
          a, () => {cohorts = cohorts.where((i) => i.id != a.id).toList()}));
    }
    return cohorts;
  }

  @override
  Future<List<ICompany>> getJoinedCompanys({bool reload = false}) async {
    if (!reload && joinedCompany.isNotEmpty) {
      return joinedCompany;
    }
    final res = await getjoinedTargets(companyTypes, id);
    if (res.result != null) {
      joinedCompany = [];
      for (var a in res.result!) {
        late ICompany company;
        switch (a.typeName as TargetType) {
          case TargetType.university:
            company = University(a, id);
            break;
          case TargetType.hospital:
            company = Hospital(a, id);
            break;
          default:
            company = Company(a, id);
            break;
        }
        joinedCompany.add(company);
      }
    }
    return joinedCompany;
  }

  Future<ICohort?> _createCohort(avatar, name, code, remark) async {
    final res = await createTarget(TargetModel(
      code: code,
      name: name,
      avatar: avatar,
      teamCode: code,
      teamName: name,
      belongId: id,
      typeName: TargetType.cohort.name,
      teamRemark: remark,
    ));
    if (res.success && res.data != null) {
      final cohort = Cohort(
          res.data!,
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
  Future<IProduct> createProduct(ProductModel data) async {
    final prod = await super.createProduct(data);
    if (prod) {
      usefulProduct.add(prod.prod);
      if (prod.prod.resource) {
        usefulResource[prod.prod.id] = prod.prod.resource;
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
      joinedCompany = joinedCompany.where((a) => a.id != id).toList();
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
      joinedCompany =
          joinedCompany.where((company) => company.id != id).toList();
    }
    return res.success;
  }

  @override
  Future<XTargetArray> loadMembers(PageRequest page) async {
    if (joinedFriend.isEmpty) {
      final data = await super.loadMembers(page);
      if (data.result != null) {
        joinedFriend = data.result!;
      }
    }
    return XTargetArray(
        offset: page.offset,
        limit: page.limit,
        result: joinedFriend
            .where((a) =>
                a.code.contains(page.filter) || a.name.contains(page.filter))
            .skip(page.offset)
            .take(page.limit)
            .toList(),
        total: joinedFriend.length);
  }

  @override
  Future<bool> applyFriend(XTarget target) async {
    final joinedTarget = joinedFriend.firstWhere((a) => a.id == target.id);
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
      joinedFriend =
          joinedFriend.where((item) => !ids.contains(item.id)).toList();
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
      joinedFriend.add(relation.target!);
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
    return (await kernel.resetPassword(ResetPwdModel(
            code: target.code, password: password, privateKey: privateKey)))
        .success;
  }

  @override
  late List<ICohort> cohorts;

  @override
  late List<ICompany> joinedCompany;

  @override
  late List<XTarget> joinedFriend;

  @override
  set spaceData(SpaceType _) {}
}
