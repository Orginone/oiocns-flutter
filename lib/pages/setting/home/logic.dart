import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:orginone/dart/core/target/itarget.dart';
import 'package:orginone/pages/setting/cofig.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/department_management.dart';
import 'package:orginone/util/setting_management.dart';

import 'state.dart';

class SettingCenterController extends BaseController<SettingCenterState>
    with GetTickerProviderStateMixin {
  final SettingCenterState state = SettingCenterState();

  SettingCenterController() {
    state.tabController = TabController(length: tabTitle.length, vsync: this);
  }

  void nextLvForEnum(CompanySpaceEnum companySpaceEnum) {
    if (companySpaceEnum != CompanySpaceEnum.company) {
      Get.toNamed(Routers.relationGroup,arguments: {"companySpaceEnum":companySpaceEnum});
    }else{
      Get.toNamed(Routers.companyInfo);
    }
  }


}
