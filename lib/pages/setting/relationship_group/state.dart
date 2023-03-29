

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/target/itarget.dart';
import 'package:orginone/dart/core/thing/ispecies.dart';
import 'package:orginone/pages/setting/home/state.dart';
import 'package:orginone/util/common_tree_management.dart';
import 'package:orginone/util/department_management.dart';
import 'package:orginone/util/setting_management.dart';

class RelationGroupState extends BaseGetState{

  var selectedGroup = <String>[].obs;

  var groupData = Rxn();

  late String head;

  late bool showPopupMenu;

  late CompanySpaceEnum companySpaceEnum;


  RelationGroupState(){

    showPopupMenu = Get.arguments?['showPopupMenu']?? true;

    companySpaceEnum = Get.arguments?['companySpaceEnum']?? CompanySpaceEnum.innerAgency;
    head = "关系";
    selectedGroup.add(companySpaceEnum.label);
    switch (companySpaceEnum) {
      case CompanySpaceEnum.innerAgency:
        groupData.value = DepartmentManagement().departments;
        break;
      case CompanySpaceEnum.outAgency:
        groupData.value = SettingManagement().outAgencyGroup;
        break;
      case CompanySpaceEnum.stationSetting:
        groupData.value = SettingManagement().stations;
        break;
      case CompanySpaceEnum.companyCohort:
        groupData.value = SettingManagement().cohorts;
        break;
    }
  }
}
