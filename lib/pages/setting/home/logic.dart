import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:orginone/pages/setting/config.dart';

import 'state.dart';

class SettingCenterController extends BaseController<SettingCenterState>
    with GetTickerProviderStateMixin {
  final SettingCenterState state = SettingCenterState();

  SettingCenterController() {
    state.tabController = TabController(length: tabTitle.length, vsync: this);
  }




}
