import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/target/authority/iauthority.dart';
import 'package:orginone/dart/core/target/itarget.dart';
import 'package:orginone/dart/core/thing/species.dart';
import 'package:orginone/pages/setting/config.dart';
import 'package:orginone/pages/setting/dialog.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/common_tree_management.dart';
import 'package:orginone/util/department_management.dart';
import 'package:orginone/util/setting_management.dart';
import 'package:orginone/util/toast_utils.dart';

import '../../../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class RelationGroupController extends BaseController<RelationGroupState> {
  final RelationGroupState state = RelationGroupState();

  void removeGroup(int index) {
    state.selectedGroup.removeRange(index + 1, state.selectedGroup.length);

    if(state.companySpaceEnum!=null){
      if(state.selectedGroup.last == state.companySpaceEnum!.label){
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
              state.groupData.value = [];
            }
            break;
          case CompanySpaceEnum.outAgency:
            var list = SettingManagement().getAllOutAgency(SettingManagement().outAgencyGroup);
            try{
              state.groupData.value = list.firstWhere((element) => element.teamName == state.selectedGroup.last).subGroup;
            }catch(e){
              state.groupData.value = [];
            }
            break;
        }
      }
    }
    if(state.standardEnum!=null){
      if(state.selectedGroup.last == state.standardEnum!.label){
        switch (state.standardEnum) {
          case StandardEnum.permissionCriteria:
            state.groupData.value = SettingManagement().authority;
            break;
          case StandardEnum.classCriteria:
            state.groupData.value = [CommonTreeManagement().species];
            break;
        }
      }else{
        switch(state.standardEnum){
          case StandardEnum.permissionCriteria:
            var list = SettingManagement().getAllAuthority(SettingManagement().authority);
            try{
              state.groupData.value = list.firstWhere((element) => element.name == state.selectedGroup.last).children;
            }catch(e){
              state.groupData.value = [];
            }
            break;
          case StandardEnum.classCriteria:
            var list = CommonTreeManagement().getAllSpecies([CommonTreeManagement().species!]);
            try{
              state.groupData.value = list.firstWhere((element) => element.name == state.selectedGroup.last).children;
            }catch(e){
              state.groupData.value = [];
            }
            break;
        }
      }
    }
    if(state.userSpaceEnum!=null){
      if(state.selectedGroup.last == state.userSpaceEnum!.label){
        state.groupData.value = SettingManagement().cohorts;
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
        ICohort? cohort,
        IAuthority? iAuthority,SpeciesItem? species}) {
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
    if(iAuthority!=null){
      state.selectedGroup.add(iAuthority.name);
      state.groupData.value = iAuthority.children;
    }
    if(species!=null){
      state.selectedGroup.add(species.name);
      state.groupData.value = species.children;
    }
  }

  void onTap({ITarget? innerAgency,
    IGroup? outAgency,
    IStation? station,
    ICohort? cohort,
    IAuthority? iAuthority,SpeciesItem? species}) {
    if(state.companySpaceEnum!=null){
      switch(state.companySpaceEnum){
        case CompanySpaceEnum.innerAgency:
          Get.toNamed(Routers.departmentInfo,arguments: {'depart':innerAgency});
          break;
        case CompanySpaceEnum.outAgency:
          Get.toNamed(Routers.outAgencyInfo,arguments: {'group':outAgency});
          break;
        case CompanySpaceEnum.stationSetting:
          Get.toNamed(Routers.stationInfo,arguments: {'station':station});
          break;
        case CompanySpaceEnum.companyCohort:
          Get.toNamed(Routers.cohortInfo,arguments: {'cohort':cohort});
          break;
      }
    }else if(state.standardEnum!=null){
      switch (state.standardEnum) {
        case StandardEnum.permissionCriteria:
          Get.toNamed(Routers.permissionInfo,
              arguments: {"authority": iAuthority});
          break;
        case StandardEnum.classCriteria:
          Get.toNamed(Routers.classificationInfo,
              arguments: {"species": species});
          break;
      }
    } else if (state.userSpaceEnum != null) {
      Get.toNamed(Routers.cohortInfo, arguments: {'cohort': cohort});
    }
  }

  void operation(dynamic item, String value) async {
    switch (value) {
      case "create":
        showCreateOrganizationDialog(context, item.subTeamTypes,
            callBack: (String name, String code, String nickName,
                String identify, String remark, TargetType type) async {
              var model = TargetModel(
                  name: nickName,
                  code: code,
                  typeName: type.label,
                  teamName: name,
                  teamCode: code,
                  teamRemark: remark,
                  avatar: '',
                  belongId: '');
                await item.create(model);
            });
        break;
      case "edit":
        showCreateOrganizationDialog(context, item.subTeamTypes,
            callBack: (String name, String code, String nickName,
                String identify, String remark, TargetType type) async {
              var model = TargetModel(
                  id: item.id,
                  name: nickName,
                  code: code,
                  typeName: type.label,
                  teamName: name,
                  teamCode: code,
                  teamRemark: remark,
                  avatar: '',
                  belongId: item.target.belongId);
              await item.update(model);
            },
            code: item.target.code,
            name: item.teamName,
            nickName: item.name,
            identify: item.target.team?.code ?? "",
            remark: item.target.team?.remark ?? "",
            type: TargetType.getType(item.typeName));
        break;
      case "delete":
        bool success = await item.delete();
        if(success){
          state.groupData.remove(item);
        }else{
          ToastUtils.showMsg(msg: "删除失败");
        }
        break;
    }
  }
}

