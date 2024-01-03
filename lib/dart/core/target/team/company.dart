import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/chat/session.dart';
import 'package:orginone/dart/core/public/consts.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/dart/core/public/operates.dart';
import 'package:orginone/dart/core/target/base/belong.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/target/base/team.dart';
import 'package:orginone/dart/core/target/innerTeam/department.dart';
import 'package:orginone/dart/core/target/innerTeam/station.dart';
import 'package:orginone/dart/core/target/outTeam/cohort.dart';
import 'package:orginone/dart/core/target/outTeam/group.dart';
import 'package:orginone/dart/core/target/outTeam/storage.dart';
import 'package:orginone/dart/core/target/person.dart';
import 'package:orginone/dart/core/thing/fileinfo.dart';
import 'package:orginone/main.dart';

///单位类型接口
abstract class ICompany extends IBelong {
  //加入/管理的组织集群
  late List<IGroup> groups;

  //设立的岗位
  late List<IStation> stations;

  //设立的部门
  late List<IDepartment> departments;

  //支持的内设机构类型
  late List<String> departmentTypes;

  //退出单位
  @override
  Future<bool> exit();

  //加载组织集群
  Future<List<IGroup>> loadGroups({bool reload = false});

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
  Company(this.metadata, this.user)
      : super(metadata, [metadata.id], user: user) {
    departmentTypes = [
      TargetType.office.label,
      TargetType.working.label,
      TargetType.research.label,
      TargetType.laboratory.label,
      TargetType.department.label,
    ];
  }

  @override
  final XTarget metadata;

  @override
  final IPerson user;
  @override
  List<IGroup> groups = [];
  @override
  List<IStation> stations = [];
  @override
  List<IDepartment> departments = [];
  @override
  List<String> departmentTypes = [];
  bool _groupLoaded = false;
  bool _departmentLoaded = false;

  @override
  Future<List<IGroup>> loadGroups({bool reload = false}) async {
    if (!_groupLoaded || reload) {
      final res = await kernel.queryJoinedTargetById(GetJoinedModel(
        id: metadata.id,
        typeNames: [TargetType.group.label],
        page: pageAll,
      ));
      if (res.success) {
        _groupLoaded = true;
        storages = [];
        groups = [];

        for (var i in res.data?.result ?? []) {
          switch (TargetType.getType(i.typeName)) {
            case TargetType.storage:
              storages.add(Storage(i, [id], this));
              break;
            default:
              groups.add(Group([key], i, [id], this));
          }
        }
      }
    }
    return groups;
  }

  @override
  Future<List<IDepartment>> loadDepartments({bool reload = false}) async {
    if (!_departmentLoaded || reload) {
      final res = await kernel.querySubTargetById(GetSubsModel(
        id: metadata.id,
        subTypeNames: [
          ...departmentTypes,
          TargetType.cohort.label,
          TargetType.station.label
        ],
        page: pageAll,
      ));
      if (res.success) {
        _departmentLoaded = true;
        departments = [];
        stations = [];
        cohorts = [];

        for (var i in (res.data?.result ?? [])) {
          switch (TargetType.getType(i.typeName)) {
            case TargetType.cohort:
              cohorts.add(Cohort(i, this, id));
              break;
            case TargetType.station:
              stations.add(Station(i, this));
              break;
            default:
              departments.add(Department([key], i, this));
          }
        }
      }
    }
    return departments;
  }

  @override
  Future<IGroup?> createGroup(TargetModel data) async {
    data.typeName = TargetType.group.label;
    final metadata = await create(data);
    if (metadata != null) {
      final group = Group([key], metadata, [id], this);
      await group.deepLoad();
      groups.add(group);
      await group.pullMembers([this.metadata]);
      return group;
    }
    return null;
  }

  @override
  Future<IDepartment?> createDepartment(TargetModel data) async {
    if (!departmentTypes.contains(TargetType.getType(data.typeName))) {
      data.typeName = TargetType.department.label;
    }
    data.public = false;
    final metadata = await create(data);
    if (metadata != null) {
      final department = Department([key], metadata, this);
      await department.deepLoad();
      if (await pullSubTarget(department)) {
        departments.add(department);
        return department;
      }
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
  Future<bool> exit() async {
    if (await removeMembers([user.metadata])) {
      user.companys.removeWhere((i) => i == this);
      return true;
    }
    return false;
  }

  @override
  Future<bool> delete({bool? notity}) async {
    final success = await super.delete(notity: notity);
    if (success) {
      user.companys = user.companys.where((i) => i.key != key).toList();
    }
    return success;
  }

  @override
  List<ITarget> get subTarget {
    return [...departments, ...cohorts];
  }

  @override
  List<ITarget> get shareTarget => [this, ...groups];
  @override
  List<ITarget> get parentTarget {
    return [this, ...groups];
  }

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
    // for (final item in groups) {
    //   chats.addAll(item.chats);
    // }
    for (final item in departments) {
      chats.addAll(item.chats);
    }
    for (final item in cohorts) {
      chats.addAll(item.chats);
    }
    // for (final item in storages) {
    //   chats.addAll(item.chats);
    // }

    return chats;
  }

  @override
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
    for (var item in storages) {
      targets.addAll(item.targets);
    }
    return targets;
  }

  @override
  Future<void> deepLoad({bool? reload = false}) async {
    await Future.wait([
      loadDepartments(reload: reload!),
      loadGroups(reload: reload),
      loadMembers(reload: reload),
      loadSuperAuth(reload: reload),
      directory.loadDirectoryResource(reload: reload),
    ]);
    // for (var group in groups) {
    //   await group.deepLoad(
    //     reload: reload,
    //   );
    // }
    // for (var department in departments) {
    //   await department.deepLoad(
    //     reload: reload,
    //   );
    // }
    // for (var station in stations) {
    //   await station.deepLoad(
    //     reload: reload,
    //   );
    // }
    // for (var cohort in cohorts) {
    //   await cohort.deepLoad(
    //     reload: reload,
    //   );
    // }
    await Future.wait(groups.map((e) => e.deepLoad(reload: reload)));
    await Future.wait(departments.map((e) => e.deepLoad(reload: reload)));
    await Future.wait(stations.map((e) => e.deepLoad(reload: reload)));
    await Future.wait(cohorts.map((e) => e.deepLoad(reload: reload)));

    superAuth?.deepLoad(reload: reload);
  }

  @override
  List<OperateModel> operates({int? mode}) {
    var os = super.operates();
    if (hasRelationAuth()) {
      List<OperateModel> menus = [];

      menus.add(OperateModel.fromJson(TargetOperates.newGroup.toJson()));
      menus.add(OperateModel.fromJson(TargetOperates.newDepartment.toJson()));

      var om = OperateModel(
          sort: 2,
          cmd: 'setNew',
          label: '设立更多',
          iconType: 'setNew',
          menus: menus);
      os.insert(0, om);
      os.insert(0, OperateModel.fromJson(CompanyJoins().toJson()));
    }

    return os;
  }

  @override
  List<IFile> content({bool? args}) {
    return [
      ...groups.map((e) => e as IFile),
      ...departments.map((e) => e as IFile),
      ...cohorts.map((e) => e as IFile),
      ...storages.map((e) => e as IFile)
    ];
  }

  @override
  Future<bool> removeMembers(
    List<XTarget> members, {
    bool? notity = false,
  }) async {
    notity = await super.removeMembers(members, notity: notity);
    if (notity) {
      for (var a in subTarget) {
        a.removeMembers(members, notity: true);
      }
    }
    return notity;
  }

  Future<String> _removeJoinTarget(XTarget target) async {
    var index = [...groups, ...storages].indexWhere((i) => i.id == target.id);
    var find = [...groups, ...storages].firstWhere((i) => i.id == target.id);
    if (index != -1) {
      await find.delete(notity: true);
      return '$name已被从${target.name}移除.';
    }
    return '';
  }

  Future<String> _addJoinTarget(XTarget target) async {
    switch (TargetType.getType(target.typeName ?? '')) {
      case TargetType.group:
        if (groups.every((i) => i.id != target.id)) {
          final group = Group([key], target, [id], this);
          await group.deepLoad();
          groups.add(group);
          return '$name已成功加入到${target.name}.';
        }
        break;
      case TargetType.storage:
        if (storages.every((i) => i.id != target.id)) {
          final storage = Storage(target, [], this);
          await storage.deepLoad();
          storages.add(storage);
          return '$name已成功加入到${target.name}.';
        }
        break;
      default:
    }
    return '';
  }

  Future<String> _addSubTarget(XTarget target) async {
    switch (TargetType.getType(target.typeName ?? '')) {
      case TargetType.cohort:
        if (cohorts.every((i) => i.id != target.id)) {
          final cohort = Cohort(target, this, id);
          await cohort.deepLoad();
          cohorts.add(cohort);
          return '$name创建了${target.name}.';
        }
        break;
      case TargetType.station:
        if (stations.every((i) => i.id != target.id)) {
          final station = Station(target, this);
          await station.deepLoad();
          stations.add(station);
          return '$name创建了${target.name}.';
        }
        break;
      default:
        if (departmentTypes.contains(target.typeName)) {
          if (departments.every((i) => i.id != target.id)) {
            final department = Department([key], target, this);
            await department.deepLoad();
            departments.add(department);
            return '$name创建了${target.name}.';
          }
        }
        break;
    }
    return '';
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
