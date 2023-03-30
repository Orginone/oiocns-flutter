


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/target/itarget.dart';

class DepartmentInfoState extends BaseGetState{
  late ITarget depart;

  SettingController settingController = Get.find<SettingController>();

  late TabController tabController;

  var index = 0.obs;

  DepartmentInfoState(){
    depart = Get.arguments['depart'];
  }
}

List<String> tabTitle = [
  "部门成员",
  "部门应用",
];

List<String> userTitle = [
  "账号",
  "昵称",
  "姓名",
  "手机号",
  "签名",
];
