

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/pages/setting/config.dart';
import 'package:orginone/util/common_tree_management.dart';
import 'package:orginone/util/department_management.dart';
import 'package:orginone/util/setting_management.dart';

class RelationGroupState extends BaseGetState{

  var selectedGroup = <String>[].obs;

  var groupData = <dynamic>[].obs;

  late String head;

  late bool showPopupMenu;

  CompanySpaceEnum? companySpaceEnum;

  StandardEnum? standardEnum;

  UserSpaceEnum? userSpaceEnum;

  RelationGroupState(){

    showPopupMenu = Get.arguments?['showPopupMenu']?? true;

    companySpaceEnum = Get.arguments?['companySpaceEnum'];

    standardEnum = Get.arguments?['standardEnum'];

    userSpaceEnum = Get.arguments?['userSpaceEnum'];

    head = Get.arguments?['head'];
    if(companySpaceEnum!=null){
      selectedGroup.add(companySpaceEnum!.label);
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
    if(standardEnum!=null){
      selectedGroup.add(standardEnum!.label);
      switch(standardEnum){
        case StandardEnum.permissionCriteria:
          groupData.value = SettingManagement().authority;
          break;
        case StandardEnum.classCriteria:
          groupData.value = [CommonTreeManagement().species];
          break;
      }
    }
    if(userSpaceEnum!=null){
      selectedGroup.add(userSpaceEnum!.label);
      groupData.value = SettingManagement().cohorts;

    }
  }
}
