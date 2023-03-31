import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';

class SettingCenterState extends BaseGetState {
  late TabController tabController;

}

const List<String> tabTitle = [
  '关系',
  '标准',
];
