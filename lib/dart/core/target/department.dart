import 'package:orginone/dart/core/target/working.dart';

import '../../base/model.dart';
import '../../base/schema.dart';
import '../enum.dart';
import 'base.dart';
import 'itarget.dart';

/*
 * 部门的元操作
 */
class Department extends BaseTarget implements IDepartment {
  final Function _onDeleted;

  Department(XTarget target, this._onDeleted) : super(target) {
    workings = [];
    departments = [];
    if ([TargetType.department, TargetType.college]
        .contains(typeName as TargetType)) {
      subTeamTypes = [...subDepartmentTypes, TargetType.working];
    } else {
      subTeamTypes = [TargetType.jobCohort, TargetType.working];
    }
    if (typeName == TargetType.college.name) {
      subTeamTypes.remove(TargetType.major);
    }
    createTargetType = [...subTeamTypes];
  }
  @override
  List<ITarget> get subTeam {
    return [...departments, ...workings];
  }

  @override
  Future<List<ITarget>> loadSubTeam({bool reload = false}) async {
    await getDepartments(reload: reload);
    await getWorkings(reload: reload);
    return [...departments, ...workings];
  }

  @override
  Future<ITarget?> create(TargetModel data) async {
    switch (data.typeName as TargetType) {
      case TargetType.working:
        return createWorking(data);
      default:
        return createDepartment(data);
    }
  }

  @override
  Future<bool> delete() async {
    final res = await deleteTarget();
    if (res.success) {
      _onDeleted(this, []);
    }
    return res.success;
  }

  @override
  Future<List<IDepartment>> getDepartments({bool reload = false}) async {
    if (!reload && departments.isNotEmpty) {
      return departments;
    }
    final res = await super.getSubTargets(departmentTypes);
    if (res.success && res.data?.result != null) {
      departments = res.data!.result
              ?.map((a) => Department(
                  a,
                  () => {
                        departments =
                            departments.where((i) => i.id != a.id).toList()
                      }))
              .toList() ??
          [];
    }
    return departments;
  }

  @override
  Future<List<IWorking>> getWorkings({bool reload = false}) async {
    if (!reload && workings.isNotEmpty) {
      return workings;
    }
    final res = await super.getSubTargets([TargetType.working]);
    if (res.success && res.data?.result != null) {
      res.data!.result?.map((a) => Working(
          a, () => {workings = workings.where((i) => i.id != a.id).toList()}));
    }
    return workings;
  }

  @override
  Future<IDepartment?> createDepartment(TargetModel data) async {
    data.belongId = target.belongId;
    data.teamCode = data.teamCode == "" ? data.code : data.teamCode;
    data.teamName = data.teamName == "" ? data.name : data.teamName;
    if (!subTeamTypes.contains(data.typeName as TargetType)) {
      // logger.warn("不支持该机构");
      return null;
    }
    final res = await super.createSubTarget(data);
    if (res.success && res.data != null) {
      final department = Department(
          res.data!,
          () => {
                departments =
                    departments.where((i) => i.id != res.data!.id).toList()
              });
      departments.add(department);
      return department;
    }
    return null;
  }

  @override
  Future<bool> deleteDepartment(id) async {
    final res = await super
        .deleteSubTarget(id, TargetType.department.name, target.belongId);
    if (res.success) {
      departments = departments.where((a) => a.target.id != id).toList();
    }
    return res.success;
  }

  @override
  Future<IWorking?> createWorking(TargetModel data) async {
    data.teamCode = data.teamCode == "" ? data.code : data.teamCode;
    data.teamName = data.teamName == "" ? data.name : data.teamName;
    final res = await super.createSubTarget(data);
    if (res.success) {
      final working = Working(
          res.data!,
          () => {
                workings = workings.where((i) => i.id != res.data!.id).toList()
              });
      workings.add(working);
      return working;
    }
    return null;
  }

  @override
  Future<bool> deleteWorking(String id) async {
    final res = await super
        .deleteSubTarget(id, TargetType.working.name, target.belongId);
    if (res.success) {
      workings = workings.where((a) => a.target.id != id).toList();
      return true;
    }
    return false;
  }

  @override
  late List<IDepartment> departments;

  @override
  late List<IWorking> workings;
}
