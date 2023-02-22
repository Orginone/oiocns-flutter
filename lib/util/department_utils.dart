import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/target/itarget.dart';
import 'package:orginone/util/hive_utils.dart';

class DepartmentUtils {
  static final DepartmentUtils _instance = DepartmentUtils._();

  factory DepartmentUtils() => _instance;

  DepartmentUtils._();

  SettingController get setting => Get.find<SettingController>();

  late List<ITarget> _departments;

  List<ITarget> get departments => _departments;

  Future<void> initDepartment() async {
    _departments = [];
    var list = await setting.company!.loadSubTeam(reload: true);
    _departments.addAll(list);
    if (_departments.isNotEmpty) {
      await loopDepartment(_departments);
      await loopMembers(_departments);
    }
  }

  ITarget? findITargetById(String id){
    var list = getAllDepartment(_departments);
    if(list.isNotEmpty){
      return list.where((element) => element.id == id || element.name == id).first;
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


  XTarget? findXTargetById(String id){
    var list = getAllUser(_departments);
    if(list.isNotEmpty){
      return list.where((element) => element.id == id || element.name == id).first;
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
    return setting.company?.name ?? "";
  }
  ITarget? get currentDepartment => _getCurrentDepartment(_departments);


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
