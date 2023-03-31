import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';

class SettingCenterState extends BaseGetState {
  late TabController tabController;

  SettingController get setting => Get.find<SettingController>();

  var selectedGroup = <String>[].obs;

  var groupData = Rxn();
}

const List<String> tabTitle = [
  '关系',
  '标准',
];


const userSpace = [
  '个人信息',
  '个人群组',
];
