

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

  SpaceEnum? spaceEnum;
  StandardEnum? standardEnum;


  bool get isStandard => standardEnum!=null;
  RelationGroupState(){

    showPopupMenu = Get.arguments?['showPopupMenu']?? true;

    spaceEnum = Get.arguments?['spaceEnum'];

    standardEnum = Get.arguments?['standardEnum'];

    head = Get.arguments?['head'];
    if(spaceEnum!=null){
      selectedGroup.add(spaceEnum!.label);
      switch (spaceEnum) {
        case SpaceEnum.innerAgency:
          groupData.value = DepartmentManagement().departments;
          break;
        case SpaceEnum.outAgency:
          groupData.value = SettingManagement().outAgencyGroup;
          break;
        case SpaceEnum.stationSetting:
          groupData.value = SettingManagement().stations;
          break;
        case SpaceEnum.personGroup:
        case SpaceEnum.companyCohort:
          groupData.value = SettingManagement().cohorts;
          break;
      }
    }
    if(standardEnum!=null){
      selectedGroup.add(standardEnum!.label);
      switch(standardEnum){
        case StandardEnum.permission:
          groupData.value = SettingManagement().authority;
          break;
        case StandardEnum.classCriteria:
          groupData.value = [CommonTreeManagement().species];
          break;
      }
    }
  }
}
