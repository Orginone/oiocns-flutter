import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:orginone/dart/core/target/itarget.dart';
import 'package:orginone/pages/setting/config.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/hive_utils.dart';
import 'package:orginone/util/local_store.dart';

import 'state.dart';

class SettingCenterController extends BaseController<SettingCenterState>{

  final SettingCenterState state = SettingCenterState();

  void jumpInfo(ISpace space) {
    if(state.settingCtrl.isUserSpace(space: space)){
      Get.toNamed(Routers.userInfo);
    }else{
      Get.toNamed(Routers.companyInfo,arguments: {"company":space});
    }

  }

  void jumpSetting(ISpace space) {
    Get.toNamed(Routers.settingFunction,arguments: {"space":space});
  }

  void jumpLogin() async{
    await LocalStore.getStore().remove('account');
    await HiveUtils.clean();
    Get.offAllNamed(Routers.login);
  }

}
