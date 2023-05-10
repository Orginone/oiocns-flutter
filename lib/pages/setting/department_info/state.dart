


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/target/base/target.dart';

class DepartmentInfoState extends BaseGetState{
  late Rx<ITarget> depart;

  SettingController settingController = Get.find<SettingController>();

  late TabController tabController;

  var index = 0.obs;

  DepartmentInfoState(){
    depart = Rx(Get.arguments['depart']);
  }
}

List<String> tabTitle = [
  "部门成员",
  "部门应用",
];
