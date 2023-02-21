import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/target/itarget.dart';

class DepartmentUtils {
  static final DepartmentUtils _instance = DepartmentUtils._();

  factory DepartmentUtils() => _instance;

  DepartmentUtils._();

  SettingController get setting => Get.find<SettingController>();

  late List<IDepartment> _departments;

  List<IDepartment> get departments =>_departments;

  Future<void> initDepartment() async {

    _departments = await setting.company!.getDepartments(reload: true);
    if (_departments.isNotEmpty) {
      loop(_departments);
    }
  }

  void loop(List<IDepartment> department) {
    for (var element in department) {
      element.loadMembers(PageRequest(offset: 0, limit: 20000, filter: ""));
      if (element.departments.isNotEmpty) {
        loop(element.departments);
      }
    }
  }

  String getCurrentCompanyName(){
    return setting.company?.name??"";
  }



}
