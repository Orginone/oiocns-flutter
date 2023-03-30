import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/target/itarget.dart';
import 'package:orginone/dart/core/thing/ispecies.dart';
import 'package:orginone/event/choice.dart';
import 'package:orginone/pages/setting/home/state.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/common_tree_management.dart';
import 'package:orginone/util/department_management.dart';
import 'package:orginone/util/event_bus_helper.dart';
import 'package:orginone/util/setting_management.dart';

import '../../../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class RelationGroupController extends BaseController<RelationGroupState> {
  final RelationGroupState state = RelationGroupState();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
  }

  void removeGroup(int index) {
    state.selectedGroup.removeRange(index + 1, state.selectedGroup.length);

    if(state.selectedGroup.last == state.companySpaceEnum.label){
      switch (state.companySpaceEnum) {
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
    }else{
      switch(state.companySpaceEnum){
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

    state.selectedGroup.refresh();
  }

  void back() {
    Get.back();
  }

  void nextLv(
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

  void onTap({ITarget? innerAgency,
    IGroup? outAgency,
    IStation? station,
    ICohort? cohort}) {
    switch(state.companySpaceEnum){
      case CompanySpaceEnum.innerAgency:
        Get.toNamed(Routers.departmentInfo,arguments: {'depart':innerAgency});
        break;
      case CompanySpaceEnum.outAgency:
        Get.toNamed(Routers.outAgencyInfo,arguments: {'group':outAgency});
        break;
      case CompanySpaceEnum.stationSetting:
        // TODO: Handle this case.
        break;
      case CompanySpaceEnum.companyCohort:
        // TODO: Handle this case.
        break;
    }
  }
}

