import 'package:flutter/material.dart';
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
import 'package:orginone/dart/core/thing/file_info.dart';
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

  Company(XTarget metadata, IPerson user) : super(metadata, ['全员群'], user) {
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
          id: member.id!,
          subId: metadata.id!,
        ));
      }
    }
    return true;
  }

  @override
  // TODO: implement chats
  List<IMsgChat> get chats {
    final chats = <IMsgChat>[this];
    chats.addAll(cohortChats);
    chats.addAll(memberChats);
    return chats;
  }

  @override
  // TODO: implement cohortChats
  List<IMsgChat> get cohortChats {
    final chats = <IMsgChat>[];
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
      // chats.addAll(superAuth!.chats);
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
  Future<void> deepLoad({bool reload = false,bool reloadContent = false}) async {
    await Future.wait([
      loadGroups(reload: reload),
      loadDepartments(reload: reload),
      loadStations(reload: reload),
      loadCohorts(reload: reload),
      loadMembers(reload: reload),
      loadSuperAuth(reload: reload),
      directory.loadContent(reload: reloadContent),
    ]);

    for (var group in groups) {
      group.deepLoad(reload: reload, reloadContent: reloadContent);
    }
    for (var department in departments) {
      department.deepLoad(reload: reload, reloadContent: reloadContent);
    }
    for (var station in stations) {
      station.deepLoad(reload: reload, reloadContent: reloadContent);
    }
    for (var cohort in cohorts) {
      cohort.deepLoad(reload: reload,reloadContent: reloadContent);
    }
    superAuth?.deepLoad(reload: reload);
  }

  @override
  Future<bool> delete() async {
    final res = await kernel.deleteTarget(IdReq(
      id: metadata.id!,
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
        id: metadata.id!,
        subTypeNames: [TargetType.cohort.label],
        page: PageRequest(offset: 0, limit: 9999, filter: ''),
      ));
      if (res.success) {
        cohorts = (res.data?.result ?? []).map((i) => Cohort(this, i)).toList();
      }
    }
    return cohorts;
  }

  @override
  Future<List<IDepartment>> loadDepartments({bool reload = false}) async {
    if (departments.isEmpty || reload) {
      final res = await kernel.querySubTargetById(GetSubsModel(
        id: metadata.id!,
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
        id: metadata.id!,
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
        id: metadata.id!,
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
  void loadMemberChats(List<XTarget> members, bool isAdd) {
    members = members.where((i) => i.id != userId).toList();
    if (isAdd) {
      for (var i in members) {
        var item = PersonMsgChat(
          belong,
          i.id!,
          ShareIcon(
              name: i.name!,
              typeName: i.typeName!,
              avatar: FileItemShare.parseAvatar(i.icon)),
          [metadata.name!, '同事'],
          i.remark ?? "",
          this,
        );
        memberChats.add(item);
      }
    } else {
      var chats = <PersonMsgChat>[];
      for (var a in memberChats) {
        for (var i in members) {
          if (a.chatId != i.id) {
            chats.add(a);
          }
        }
      }
      memberChats = chats;
    }
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
    for (var item in cohorts) {
      targets.addAll(item.targets);
    }
    return targets;
  }

  @override
  // TODO: implement shareTarget
  List<ITarget> get shareTarget => [this, ...groups];

  @override
  // TODO: implement popupMenuItem
  List<PopupMenuItem> get popupMenuItem {
    List<PopupMenuKey> key = [];
    if(hasRelationAuth()){
      key.addAll([...createPopupMenuKey,PopupMenuKey.updateInfo,PopupMenuKey.createDepartment,PopupMenuKey.createStation,PopupMenuKey.createGroup,]);
    }
    key.addAll(defaultPopupMenuKey);
    return key
        .map((e) => PopupMenuItem(
      value: e,
      child: Text(e.label),
    ))
        .toList();
  }

  @override
  bool isLoaded = false;

  @override
  Future<bool> teamChangedNotity(XTarget target) async{
    switch (TargetType.getType(target.typeName!)) {
      case TargetType.person:
        return await pullMembers([target]);
      case TargetType.group:
        if (!groups.any((i) => i.id == target.id)) {
          final group = Group(target, this);
          await group.deepLoad();
          groups.add(group);
          return true;
        }
        break;
      case TargetType.station:
        if (!stations.any((i) => i.id == target.id)) {
          final station = Station(target, this);
          await station.deepLoad();
          stations.add(station);
          return true;
        }
        break;
      case TargetType.cohort:
        if (!cohorts.any((i) => i.id == target.id)) {
          final cohort = Cohort(this,target);
          await cohort.deepLoad();
          cohorts.add(cohort);
          return true;
        }
        break;
      default:
        if (departmentTypes.contains(target.typeName as TargetType)) {
          if (!departments.any((i) => i.id == target.id)) {
            final department = Department(target, this);
            await department.deepLoad();
            departments.add(department);
            return true;
          }
        }
    }
    return false;
  }

  @override
  List<IFileInfo<XEntity>> content(int mode) {
    return [];
  }

  @override
  // TODO: implement locationKey
  String get locationKey => '';
}
