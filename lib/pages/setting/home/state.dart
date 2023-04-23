import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_get_breadcrumb_nav_state.dart';
import 'package:orginone/dart/core/target/itarget.dart';

class SettingCenterState extends BaseBreadcrumbNavState {
  SettingController get settingCtrl => Get.find<SettingController>();
  late List<BaseBreadcrumbNavModel> spaces;

  SettingCenterState(){
    spaces = [];
    var joinedCompanies = settingCtrl.user!.joinedCompany;
    spaces.add(
        BaseBreadcrumbNavModel(name: settingCtrl.user?.teamName??"",id:  settingCtrl.user?.id??"",image:settingCtrl.user?.target.avatarThumbnail(),source:  settingCtrl.user)
    );
    for (var element in joinedCompanies) {
      spaces.add(
          BaseBreadcrumbNavModel(name: element.teamName,id: element.id,image: element.target.avatarThumbnail(),source: element)
      );
    }
    title = "设置";
  }
}
