import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/chat/message/msgchat.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/target/base/belong.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/target/base/team.dart';
import 'package:orginone/dart/core/target/innerTeam/department.dart';
import 'package:orginone/dart/core/target/innerTeam/station.dart';
import 'package:orginone/dart/core/target/out_team/cohort.dart';
import 'package:orginone/dart/core/target/out_team/group.dart';
import 'package:orginone/dart/core/target/person.dart';
import 'package:orginone/dart/core/thing/app/application.dart';
import 'package:orginone/main.dart';

abstract class ICompany extends IBelong {
  //管理的单位群
  late List<IGroup> groups;

  //设立的岗位
  late List<IStation> stations;

  //设立的部门
  late List<IDepartment> departments;

  //支持的内设机构类型
  late List<TargetType> departmentTypes;

  //退出单位
  Future<bool> exit();

  //加载单位群
  Future<List<IGroup>> loadGroups({bool reload = false});

  //加载创建的群
  Future<List<IStation>> loadStations({bool reload = false});

  //加载单位的部门
  Future<List<IDepartment>> loadDepartments({bool reload = false});

  //设立岗位
  Future<IStation?> createStation(TargetModel data);

  //设立单位群
  Future<IGroup?> createGroup(TargetModel data);

  //设立内部机构
  Future<IDepartment?> createDepartment(TargetModel data);
}

class Company extends Belong implements ICompany {
  @override
  late List<TargetType> departmentTypes;

  @override
  late List<IDepartment> departments;

  @override
  late List<IGroup> groups;

  @override
  late List<IStation> stations;

  Company(XTarget metadata,IPerson user):super(metadata,['全员群'],user){
    departmentTypes = [
      TargetType.office,
      TargetType.working,
      TargetType.research,
      TargetType.laboratory,
      TargetType.department,
    ];
    departments = [];
    groups = [];
    stations = [];
  }

  @override
  Future<bool> applyJoin(List<XTarget> members) async {
    for (final member in members) {
      if (member.typeName == TargetType.group.label) {
        await kernel.applyJoinTeam(GainModel(
          id: member.id,
          subId: metadata.id,
        ));
      }
    }
    return true;
  }

  @override
  // TODO: implement chats
  List<IChat> get chats {
    final chats = <IChat>[this];
    chats.addAll(cohortChats);
    chats.addAll(memberChats);
    return chats;
  }

  @override
  // TODO: implement cohortChats
  List<IChat> get cohortChats {
    final chats = <IChat>[];
    for (final item in departments) {
      chats.addAll(item.chats);
    }
    for (final item in stations) {
      chats.addAll(item.chats);
    }
    for (final item in cohorts) {
      chats.addAll(item.chats);
    }
    if (superAuth != null) {
      chats.addAll(superAuth!.chats);
    }
    return chats;
  }

  @override
  Future<IDepartment?> createDepartment(TargetModel data) async {
    if (!departmentTypes.contains(TargetType.getType(data.typeName))) {
      data.typeName = TargetType.department.label;
    }
    data.public = false;
    final metadata = await create(data);
    if (metadata != null) {
      var department = Department(metadata, this);
      if (await pullSubTarget(department)) {
        departments.add(department);
        return department;
      }
    }
    return null;
  }

  @override
  Future<IGroup?> createGroup(TargetModel data) async {
    data.typeName = TargetType.group.label;
    final metadata = await create(data);
    if (metadata != null) {
      final group = Group(metadata, this);
      groups.add(group);
      await group.pullMembers([metadata]);
      return group;
    }
    return null;
  }

  @override
  Future<IStation?> createStation(TargetModel data) async {
    data.public = false;
    data.typeName = TargetType.station.label;
    final metadata = await create(data);
    if (metadata != null) {
      final station = Station(metadata, this);
      if (await pullSubTarget(station)) {
        stations.add(station);
        return station;
      }
    }
    return null;
  }

  @override
  Future<ITeam?> createTarget(TargetModel data) {
    switch (TargetType.getType(data.typeName)) {
      case TargetType.cohort:
        return createCohort(data);
      case TargetType.station:
        return createStation(data);
      case TargetType.group:
        return createGroup(data);
      default:
        return createDepartment(data);
    }
  }

  @override
  Future<void> deepLoad({bool reload = false}) async{
    await loadGroups(reload: reload);
    await loadDepartments(reload: reload);
    await loadStations(reload: reload);
    await loadCohorts(reload: reload);
    await loadMembers(reload: reload);
    await loadSuperAuth(reload: reload);
    await loadDicts(reload: reload);
    await loadSpecies(reload: reload);
    for (var group in groups) {
      await group.deepLoad(reload: reload);
    }
    for (var department in departments) {
      await department.deepLoad(reload: reload);
    }
    for (var station in stations) {
      await station.deepLoad(reload: reload);
    }
    for (var cohort in cohorts) {
       cohort.deepLoad(reload: reload);
    }
    superAuth?.deepLoad(reload: reload);
  }

  @override
  Future<bool> delete() async {
    final res = await kernel.deleteTarget(IdReq(
      id: metadata.id,
    ));
    if (res.success) {
      user.companys.removeWhere((i) => i == this);
    }
    return res.success;
  }

  @override
  Future<bool> exit() async {
    if (await removeMembers([user.metadata])) {
      user.companys.removeWhere((i) => i == this);
      return true;
    }
    return false;
  }

  @override
  Future<List<ICohort>> loadCohorts({bool reload = false}) async {
    if (cohorts.isEmpty || reload) {
      final res = await kernel.querySubTargetById(GetSubsModel(
        id: metadata.id,
        subTypeNames: [TargetType.cohort.label],
        page: PageRequest(offset: 0, limit: 9999, filter: ''),
      ));
      if (res.success) {
        cohorts = (res.data?.result ?? []).map((i) => Cohort(this,i)).toList();
      }
    }
    return cohorts;
  }

  @override
  Future<List<IDepartment>> loadDepartments({bool reload = false}) async {
    if (departments.isEmpty || reload) {
      final res = await kernel.querySubTargetById(GetSubsModel(
        id: metadata.id,
        subTypeNames: departmentTypes.map((e) => e.label).toList(),
        page: PageRequest(offset: 0, limit: 9999, filter: ''),
      ));
      if (res.success) {
        departments =
            (res.data?.result ?? []).map((i) => Department(i, this)).toList();
      }
    }
    return departments;
  }

  @override
  Future<List<IGroup>> loadGroups({bool reload = false}) async {
    if (groups.isEmpty || reload) {
      final res = await kernel.queryJoinedTargetById(GetJoinedModel(
        id: metadata.id,
        typeNames: [TargetType.group.label],
        page: PageRequest(offset: 0, limit: 9999, filter: ''),
      ));
      if (res.success) {
        groups = (res.data?.result ?? []).map((i) => Group(i, this)).toList();
      }
    }
    return groups;
  }

  @override
  Future<List<IStation>> loadStations({bool reload = false}) async {
    if (stations.isEmpty || reload) {
      final res = await kernel.querySubTargetById(GetSubsModel(
        id: metadata.id,
        subTypeNames: [TargetType.station.label],
        page: PageRequest(offset: 0, limit: 9999, filter: ''),
      ));
      if (res.success) {
        stations =
            (res.data?.result ?? []).map((i) => Station(i, this)).toList();
      }
    }
    return stations;
  }

  @override
  // TODO: implement parentTarget
  List<ITarget> get parentTarget {
    return [this, ...groups];
  }

  @override
  // TODO: implement subTarget
  List<ITarget> get subTarget {
    return [...departments, ...cohorts];
  }

  @override
  // TODO: implement workSpecies
  List<IApplication> get workSpecies {
    final workItems = species.where(
          (a) => a.metadata.typeName == SpeciesType.application.label,
    ) as List<IApplication>;
    for (final item in cohorts) {
      workItems.addAll(item.workSpecies);
    }
    for (final group in groups) {
      workItems.addAll(group.workSpecies);
    }
    return workItems;
  }

  @override
  void loadMemberChats(List<XTarget> members, bool isAdd) {
    members
        .where((i) => i.id != user.metadata.id)
        .forEach((i) {
      if (isAdd) {
        memberChats.add(
          PersonMsgChat(
              user.metadata.id,
              metadata.id,
              i.id,
              TargetShare(
                  name: i.name, typeName: i.typeName,avatar: FileItemShare.
                  parseAvatar(i.icon)),
          ['同事'],
          i.remark??"",
        ),
      );
      } else {
      memberChats.removeWhere(
      (a) => a.belongId == i.id && a.chatId == i.id,
      );
      }
    });
  }

  @override
  // TODO: implement targets
  List<ITarget> get targets {
    List<ITarget> targets = [this];
    for (var item in groups) {
      targets.addAll(item.targets);
    }
    for (var item in departments) {
      targets.addAll(item.targets);
    }
    return targets;
  }
}
