import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:orginone/dart/core/target/itarget.dart';
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
      state.selectedGroup.add(companySpaceEnum.label);
    }
    initGroupData(companySpaceEnum);
  }

  void initGroupData(CompanySpaceEnum companySpaceEnum){
    switch (companySpaceEnum) {
      case CompanySpaceEnum.innerAgency:
        state.groupData.value = DepartmentManagement().departments;
        break;
      case CompanySpaceEnum.outAgency:
        state.groupData.value = SettingManagement().outAgencyGroup;
        break;
      case CompanySpaceEnum.stationSetting:
        state.groupData.value = SettingManagement().stations;
        break;
      case CompanySpaceEnum.companyCohort:
        state.groupData.value = SettingManagement().cohorts;
        break;
    }
  }

  void nextLvForGroup(
      {ITarget? innerAgency,
      IGroup? outAgency,
      IStation? station,
      ICohort? cohort}) {
     if(innerAgency!=null){
       state.selectedGroup.add(innerAgency.teamName);
       state.groupData.value = innerAgency.subTeam;
     }
     if(outAgency!=null){
       state.selectedGroup.add(outAgency.teamName);
       state.groupData.value = outAgency.subGroup;
     }
     if(station!=null){
       state.selectedGroup.add(station.teamName);
       state.groupData.value = station.subTeam;
     }
     if(cohort!=null){
       state.selectedGroup.add(cohort.teamName);
       state.groupData.value = cohort.subTeam;
     }
  }

  void clearGroup() {
    state.selectedGroup.clear();
    state.groupData.value = null;
  }

  void removeGroup(int index) {
    state.selectedGroup.removeRange(index + 1, state.selectedGroup.length);

    String groupName = getGroupName();

    if(state.selectedGroup.last == ''){

    }

    if(groupName.isEmpty){
      state.groupData.value = null;
    }else{
      var e = CompanySpaceEnum.findEnum(groupName);
      if(state.selectedGroup.last == groupName){
        initGroupData(e);
      }else{
        switch(e){
          case CompanySpaceEnum.innerAgency:
            var list = DepartmentManagement().getAllDepartment(DepartmentManagement().departments);
            try{
              state.groupData.value = list.firstWhere((element) => element.teamName == state.selectedGroup.last).subTeam;
            }catch(e){
              state.groupData.value = null;
            }
            break;
          case CompanySpaceEnum.outAgency:
            var list = SettingManagement().getAllOutAgency(SettingManagement().outAgencyGroup);
            try{
              state.groupData.value = list.firstWhere((element) => element.teamName == state.selectedGroup.last).subGroup;
            }catch(e){
              state.groupData.value = null;
            }
            break;
        }
      }
    }
    state.selectedGroup.refresh();
  }

  String getGroupName(){
    for (var element in state.selectedGroup) {
      if(companySpace.contains(element)){
        return element;
      }
    }
    return '';
  }

}
