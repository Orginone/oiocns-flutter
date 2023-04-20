import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/target/itarget.dart';
import 'package:orginone/util/hive_utils.dart';

import 'toast_utils.dart';

class DepartmentManagement {
  static final DepartmentManagement _instance = DepartmentManagement._();

  factory DepartmentManagement() => _instance;

  DepartmentManagement._();

  SettingController get _setting => Get.find<SettingController>();

  final List<ITarget> _departments = [];

  List<ITarget> get departments => _departments;

  Future<void> initDepartment() async {
    var list = await _setting.company?.loadSubTeam(reload: true)??[];
    _departments.clear();
    if(list.isNotEmpty){
      _departments.addAll(list);
      if (_departments.isNotEmpty) {
        await loopDepartment(_departments);
        await loopMembers(_departments);
      }
    }else{
      // ToastUtils.showMsg(msg: "获取分组分类数据失败");
      print('获取分组分类数据失败');
    }
  }

  Future<List<ITarget>> spaceGetDepartment(ISpace space) async {
    var list = await space.loadSubTeam(reload: true)??[];
    _departments.clear();
    if(list.isNotEmpty){
      await loopDepartment(list);
      await loopMembers(list);
    }
    return list;
  }

  ITarget? findITargetByIdOrName({String? id, String? name}) {
    var list = getAllDepartment(_departments);
    if (list.isNotEmpty) {
      var iter =
          list.where((element) => element.id == id || element.name == name);
      if (iter.isNotEmpty) {
        return iter.first;
      }
    }
    return null;
  }

  List<ITarget>  getAllDepartment(List<ITarget> departments) {
    List<ITarget> list = [];
    for (var element in departments) {
      list.add(element);
      if (element.subTeam.isNotEmpty) {
        list.addAll(getAllDepartment(element.subTeam));
      }
    }

    return list;
  }


  XTarget? findXTargetByIdOrName({String? id, String? name}) {
    var list = getAllUser(_departments);
    if (list.isNotEmpty) {
      var iter =
          list.where((element) => element.id == id || element.name == name);
      if (iter.isNotEmpty) {
        return iter.first;
      }
    }
    return null;
  }

  List<XTarget> getAllUser(List<ITarget> departments) {
    List<XTarget> list = [];
    for (var element in departments) {
      list.addAll(element.members);
      if (element.subTeam.isNotEmpty) {
        list.addAll(getAllUser(element.subTeam));
      }
    }
    return list;
  }

  Future<void> loopDepartment(List<ITarget> department) async {
    for (var element in department) {
      element.subTeam = await element.loadSubTeam(reload: true);
      if (element.subTeam.isNotEmpty) {
        await loopDepartment(element.subTeam);
      }
    }
  }

  Future<void> loopMembers(List<ITarget> department) async {
    for (var element in department) {
      XTargetArray members = await element
          .loadMembers(PageRequest(offset: 0, limit: 20000, filter: ""));
      if (members.result != null) {
        element.members = members.result!;
      }

      if (element.subTeam.isNotEmpty) {
        await loopMembers(element.subTeam);
      }
    }
  }

  String getCurrentCompanyName() {
    return _setting.company?.name ?? "";
  }

  ITarget? get currentDepartment => _getCurrentDepartment(_departments);

  List<XTarget> _getAllPerson(List<ITarget> target){
    List<XTarget> persons = [];

    for (var value in target) {
      persons.addAll(value.members);
      if(value.subTeam.isNotEmpty){
        persons.addAll(_getAllPerson(value.subTeam));
      }
    }

    return persons;
  }

  ITarget? _getCurrentDepartment(List<ITarget> target) {
    ITarget? department;
    for (var element in target) {
      if (element.members
          .where((element) => element.name == HiveUtils.getUser()?.userName)
          .isNotEmpty) {
        department = element;
      } else {
        if (element.subTeam.isNotEmpty) {
          department = _getCurrentDepartment(element.subTeam);
        }
      }
    }
    return department;
  }
}
