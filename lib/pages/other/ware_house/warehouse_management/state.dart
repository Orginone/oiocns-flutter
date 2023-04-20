


import 'package:get/get.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_get_breadcrumb_nav_state.dart';
import 'package:orginone/dart/core/target/itarget.dart';

class WarehouseManagementState extends BaseBreadcrumbNavState{
  SettingController get settingCtrl => Get.find<SettingController>();
  late List<ISpace> spaces;

  WarehouseManagementState(){
    title = "仓库";
    var joinedCompanies = settingCtrl.user!.joinedCompany;
    spaces = <ISpace>[...joinedCompanies];
  }
}