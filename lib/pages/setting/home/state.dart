import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/target/itarget.dart';

class SettingCenterState extends BaseGetState {
  SettingController get settingCtrl => Get.find<SettingController>();
  late List<ISpace> spaces;

  SettingCenterState(){
    var joinedCompanies = settingCtrl.user!.joinedCompany;
    spaces = <ISpace>[settingCtrl.user!,...joinedCompanies];
  }
}
