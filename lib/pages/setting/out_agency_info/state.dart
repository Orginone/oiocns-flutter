


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/target/out_team/group.dart';

class OutAgencyInfoState extends BaseGetState{
  late IGroup group;

  SettingController settingController = Get.find<SettingController>();

  late TabController tabController;

  var unitMember = <XTarget>[].obs;

  var index = 0.obs;

  OutAgencyInfoState(){
    group = Get.arguments['group'];
  }
}

List<String> tabTitle = [
  "组织群成员",
];

