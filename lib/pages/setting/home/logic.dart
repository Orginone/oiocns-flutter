import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_controller.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_get_breadcrumb_nav_state.dart';
import 'package:orginone/pages/setting/config.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/hive_utils.dart';
import 'package:orginone/util/local_store.dart';

import 'state.dart';

class SettingCenterController extends BaseBreadcrumbNavController<SettingCenterState>{

  final SettingCenterState state = SettingCenterState();

  void jumpInfo(BaseBreadcrumbNavModel model) {
    if(state.settingCtrl.isUserSpace(model.source)){
      Get.toNamed(Routers.userInfo);
    }else{
      Get.toNamed(Routers.companyInfo,arguments: {"company":model.source});
    }

  }

  void jumpSetting(BaseBreadcrumbNavModel model) {
    Get.toNamed(Routers.settingFunction,arguments: {"space":model.source});
  }

  void jumpLogin() async{
    LocalStore.clear();
    await HiveUtils.clean();
    Get.offAllNamed(Routers.login);
  }

}
