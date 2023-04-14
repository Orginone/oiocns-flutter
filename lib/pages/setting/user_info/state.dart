import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/target/itarget.dart';

class UserInfoState extends BaseGetState {

  SettingController settingController = Get.find<SettingController>();

  IPerson? get user => settingController.user;

  var unitMember = <XTarget>[].obs;

  var joinCompany = <ICompany>[].obs;

  late TabController tabController;

  var index = 0.obs;
}


List<String> tabTitle = [
  "我的好友",
  "加入的单位",
];


