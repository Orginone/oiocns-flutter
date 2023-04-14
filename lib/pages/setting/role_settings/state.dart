import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/target/authority/iidentity.dart';
import 'package:orginone/dart/core/target/itarget.dart';

class RoleSettingsState extends BaseGetState {
  late TabController tabController;
  ITarget? innerAgency;
  IGroup? outAgency;
  ICohort? cohort;
  ICompany? company;

  var identitys = <IIdentity>[].obs;

  RoleSettingsState(){
    company = Get.arguments?['company'];
    innerAgency = Get.arguments?['innerAgency'];
    outAgency = Get.arguments?['outAgency'];
    cohort = Get.arguments?['cohort'];
  }
}
