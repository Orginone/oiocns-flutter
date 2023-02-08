/*
 * 公司的元操作
 */
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/market/model.dart';
import 'package:orginone/dart/core/target/station.dart';
import 'package:orginone/dart/core/target/working.dart';

import '../../base/common/uint.dart';
import '../../base/schema.dart';
import '../enum.dart';
import 'cohort.dart';
import 'department.dart';
import 'group.dart';
import 'itarget.dart';
import 'mbase.dart';

class Company extends MarketTarget implements ICompany {
  late List<IStation> stations;
  late List<TargetType> departmentTypes;

  Company(XTarget target, String userId) : super(target) {
    userId = userId;
    departmentTypes = departmentTypes;
    subTeamTypes = [...departmentTypes, TargetType.working];
    extendTargetType = [...subTeamTypes, ...companyTypes];
    joinTargetType = [TargetType.group];
    createTargetType = [
      ...subTeamTypes,
      TargetType.station,
      TargetType.group,
      TargetType.cohort,
    ];
    searchTargetType = [TargetType.person, TargetType.group];
  }
  @override
  List<ITarget> get subTeam {
    return [...departments, ...workings];
  }

  @override
  Future<List<ICohort>> getCohorts({bool reload = false}) async {
    if (!reload && cohorts.isNotEmpty) {
      return cohorts;
    }
    final res = await kernel.queryJoinedTargetById(IDReqJoinedModel(
      id: userId,
      typeName: TargetType.person.name,
      page: PageRequest(
        offset: 0,
        filter: "",
        limit: Constants.maxUint16,
      ),
      spaceId: id,
      joinTypeNames: [TargetType.cohort.name],
    ));
    if (res.success && res.data?.result != null) {
      cohorts = res.data!.result
              ?.map((a) => Cohort(
                  a,
                  () =>
                      {cohorts = cohorts.where((i) => i.id != a.id).toList()}))
              .toList() ??
          [];
    }
    return cohorts;
  }

  @override
  Future<ITarget?> create(TargetModel data) async {
    switch (data.typeName as TargetType) {
      case TargetType.group:
        return _createGroup(data);
      case TargetType.working:
        return _createWorking(data);
      case TargetType.station:
        return _createStation(data);
      case TargetType.cohort:
        return _createCohort(data);
      default:
        return _createDepartment(data);
    }
  }

  @override
  Future<List<ITarget>> loadSubTeam({bool reload = false}) async {
    await getWorkings(reload: reload);
    await getDepartments(reload: reload);
    return [...departments, ...workings];
  }

  @override
  Future<XTargetArray> searchGroup(String code) async {
    return await searchTargetByName(code, [TargetType.group]);
  }

  @override
  SpaceType get spaceData {
    var space = SpaceType();
    space.id = target.id;
    space.name = target.team!.name;
    space.share = shareInfo;
    space.typeName = target.typeName as TargetType;
    return space;
  }

  Future<IGroup?> _createGroup(TargetModel data) async {
    final tres = await searchTargetByName(data.code, [TargetType.group]);
    if (tres.result == null) {
      data.belongId = target.id;
      final res = await createTarget(data);
      if (res.success) {
        final group = Group(
            res.data!,
            () => {
                  joinedGroup = joinedGroup
                      .where((item) => item.id != res.data!.id)
                      .toList()
                });
        joinedGroup.add(group);
        await group.pullMember(target);
        return group;
      }
    } else {
      // logger.warn("该集团已存在!");
    }
    return null;
  }

  Future<IDepartment?> _createDepartment(TargetModel data) async {
    data.belongId = target.id;
    data.teamCode = data.teamCode == "" ? data.code : data.teamCode;
    data.teamName = data.teamName == "" ? data.name : data.teamName;
    if (!departmentTypes.contains(data.typeName as TargetType)) {
      // logger.warn("不支持该机构");
      return null;
    }
    final res = await createSubTarget(data);
    if (res.success) {
      final department = Department(
          res.data!,
          () => {
                departments = departments
                    .where((item) => item.id != res.data!.id)
                    .toList()
              });
      departments.add(department);
      return department;
    }
    return null;
  }

  Future<IStation?> _createStation(TargetModel data) async {
    data.belongId = target.id;
    data.teamCode = data.teamCode == "" ? data.code : data.teamCode;
    data.teamName = data.teamName == "" ? data.name : data.teamName;
    data.typeName = TargetType.station.name;
    final res = await createSubTarget(data);
    if (res.success) {
      final station = Station(
          res.data!,
          () => {
                stations =
                    stations.where((item) => item.id != res.data!.id).toList()
              });
      stations.add(station);
      return station;
    }
    return null;
  }

  Future<IWorking?> _createWorking(TargetModel data) async {
    data.belongId = target.id;
    data.teamCode = data.teamCode == "" ? data.code : data.teamCode;
    data.teamName = data.teamName == "" ? data.name : data.teamName;
    data.typeName = TargetType.working.name;
    final res = await createSubTarget(data);
    if (res.success) {
      final working = Working(
          res.data!,
          () => {
                workings =
                    workings.where((item) => item.id != res.data!.id).toList()
              });
      workings.add(working);
      return working;
    }
    return null;
  }

  Future<ICohort?> _createCohort(TargetModel data) async {
    data.belongId = target.id;
    data.typeName = TargetType.cohort.name;
    data.teamCode = data.code;
    data.teamName = data.name;
    final res = await createTarget(data);
    if (res.success && res.data != null) {
      final cohort = Cohort(
          res.data!,
          () =>
              {cohorts = cohorts.where((i) => i.id != res.data!.id).toList()});
      cohorts.add(cohort);
      cohort.pullMembers([userId], TargetType.person.name);
      return cohort;
    }
    return null;
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
  Future<bool> deleteDepartment(String id) async {
    final department =
        departments.firstWhere((department) => department.id == id);
    if (department.id != '') {
      final res =
          await deleteSubTarget(target.id, department.target.typeName, id);
      if (res.success) {
        departments =
            departments.where((department) => department.id != id).toList();
      }
      return res.success;
    }
    // // logger.warn(unAuthorizedError);
    return false;
  }

  @override
  Future<bool> deleteStation(String id) async {
    final station = stations.firstWhere((department) => department.id == id);
    if (station.id != '') {
      final res = await deleteSubTarget(id, station.target.typeName, id);
      if (res.success) {
        stations = stations.where((station) => station.id != id).toList();
      }
      return res.success;
    }
    // logger.warn(unAuthorizedError);
    return false;
  }

  @override
  Future<bool> deleteWorking(String id) async {
    final working = workings.firstWhere((working) => working.id == id);
    if (working.id != '') {
      final res = await deleteSubTarget(id, TargetType.working.name, id);
      if (res.success) {
        workings = workings.where((working) => working.id != id).toList();
      }
      return res.success;
    }
    // logger.warn(unAuthorizedError);
    return false;
  }

  @override
  Future<bool> deleteGroup(String id) async {
    final group = joinedGroup.firstWhere((group) => group.target.id == id);
    if (group.id != '') {
      final res = await kernel.recursiveDeleteTarget(RecursiveReqModel(
        id: id,
        typeName: TargetType.group.name,
        subNodeTypeNames: [TargetType.group.name],
      ));
      if (res.success) {
        joinedGroup =
            joinedGroup.where((group) => group.target.id != id).toList();
      }
      return res.success;
    }
    // logger.warn(unAuthorizedError);
    return false;
  }

  @override
  Future<bool> quitGroup(String id) async {
    final group = joinedGroup.firstWhere((a) => a.target.id == id);
    if (group.id != '') {
      final res = await kernel.recursiveExitAnyOfTeam(ExitTeamModel(
        id: id,
        teamTypes: [TargetType.group.name],
        targetId: target.id,
        targetType: target.typeName,
      ));
      if (res.success) {
        joinedGroup = joinedGroup.where((a) => a.target.id != id).toList();
      }
      return res.success;
    }
    // logger.warn(unAuthorizedError);
    return false;
  }

  @override
  Future<List<IDepartment>> getDepartments({bool reload = false}) async {
    if (!reload && departments.isNotEmpty) {
      return departments;
    }
    final res = await getSubTargets(departmentTypes);
    if (res.success && res.data?.result != null) {
      departments = res.data!.result
              ?.map((a) => Department(
                  a,
                  () => {
                        departments = departments
                            .where((item) => item.id != a.id)
                            .toList()
                      }))
              .toList() ??
          [];
    }
    return departments;
  }

  @override
  Future<List<IStation>> getStations({bool reload = false}) async {
    if (!reload && stations.isNotEmpty) {
      return stations;
    }
    final res = await getSubTargets([TargetType.station]);
    if (res.success && res.data?.result != null) {
      stations = res.data!.result
              ?.map((a) => Station(
                  a,
                  () => {
                        stations =
                            stations.where((item) => item.id != a.id).toList()
                      }))
              .toList() ??
          [];
    }
    return stations;
  }

  @override
  Future<List<IWorking>> getWorkings({bool reload = false}) async {
    if (!reload && workings.isNotEmpty) {
      return workings;
    }
    final res = await getSubTargets([TargetType.working]);
    if (res.success && res.data?.result != null) {
      workings = res.data!.result
              ?.map((a) => Working(
                  a,
                  () => {
                        workings =
                            workings.where((item) => item.id != a.id).toList()
                      }))
              .toList() ??
          [];
    }
    return workings;
  }

  @override
  Future<List<IGroup>> getJoinedGroups({bool reload = false}) async {
    if (!reload && joinedGroup.isNotEmpty) {
      return joinedGroup;
    }
    final res = await getjoinedTargets([TargetType.group], userId);
    if (res.result != null) {
      joinedGroup = res.result
              ?.map((a) => Group(
                  a,
                  () => {
                        joinedGroup = joinedGroup
                            .where((item) => item.id != a.id)
                            .toList()
                      }))
              .toList() ??
          [];
    }
    return joinedGroup;
  }

  @override
  Future<ICompany> update(TargetModel data) async {
    // if (!validIsSocialCreditCode(data.code)) {
    //   logger.warn("请填写正确的代码!");
    // }
    await super.update(data);
    return this;
  }

  @override
  Future<bool> applyJoinGroup(String id) async {
    final group = joinedGroup.firstWhere((group) => group.target.id == id);
    if (group.id == '') {
      return await applyJoin(id, TargetType.group);
    }
    // logger.warn(consts.IsJoinedError);
    return false;
  }

  @override
  Future<XRelationArray?> queryJoinApply() async {
    return (await kernel.queryJoinTeamApply(IDBelongReq(
      id: target.id,
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
      id: target.id,
      page: PageRequest(
        offset: 0,
        filter: "",
        limit: Constants.maxUint16,
      ),
    )))
        .data;
  }

  @override
  Future<bool> cancelJoinApply(String id) async {
    final res = await kernel.cancelJoinTeam(IdReqModel(
        id: id, typeName: TargetType.company.name, belongId: target.id));
    return res.success;
  }

  @override
  late List<ICohort> cohorts;

  @override
  late List<IDepartment> departments;

  @override
  late List<IGroup> joinedGroup;

  @override
  late String userId;

  @override
  late List<IWorking> workings;

  @override
  set spaceData(SpaceType _) {}

  @override
  late List<IMarket> joinedMarkets;

  @override
  late List<IProduct> ownProducts;

  @override
  late List<IMarket> publicMarkets;
}
