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

    if(!state.isStandard){
      if(state.selectedGroup.last == state.spaceEnum!.label){
        switch (state.spaceEnum) {
          case SpaceEnum.innerAgency:
            state.groupData.value = DepartmentManagement().departments;
            break;
          case SpaceEnum.outAgency:
            state.groupData.value = SettingManagement().outAgencyGroup;
            break;
          case SpaceEnum.stationSetting:
            state.groupData.value = SettingManagement().stations;
            break;
          case SpaceEnum.personGroup:
          case SpaceEnum.companyCohort:
            state.groupData.value = SettingManagement().cohorts;
            break;
        }
      }else{
        switch(state.spaceEnum){
          case SpaceEnum.innerAgency:
            var list = DepartmentManagement().getAllDepartment(DepartmentManagement().departments);
            try{
              state.groupData.value = list.firstWhere((element) => element.teamName == state.selectedGroup.last).subTeam;
            }catch(e){
              state.groupData.value = [];
            }
            break;
          case SpaceEnum.outAgency:
            var list = SettingManagement().getAllOutAgency(SettingManagement().outAgencyGroup);
            try{
              state.groupData.value = list.firstWhere((element) => element.teamName == state.selectedGroup.last).subGroup;
            }catch(e){
              state.groupData.value = [];
            }
            break;
        }
      }
    }else{
      if(state.selectedGroup.last == state.standardEnum!.label){
        switch (state.standardEnum) {
          case StandardEnum.permission:
            state.groupData.value = SettingManagement().authority;
            break;
          case StandardEnum.classCriteria:
            state.groupData.value = [CommonTreeManagement().species];
            break;
        }
      }else{
        switch(state.standardEnum){
          case StandardEnum.permission:
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
    state.selectedGroup.refresh();
  }

  void back() {
    Get.back();
  }

  void nextLv(
      {ITarget? target,
        IAuthority? iAuthority,SpeciesItem? species}) {
    if(target!=null){
      state.selectedGroup.add(target.teamName);
      state.groupData.value = target.subTeam;
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

  void onTap({ITarget? target,
    IAuthority? iAuthority,SpeciesItem? species}) {
    if(!state.isStandard){
      switch(state.spaceEnum){
        case SpaceEnum.innerAgency:
          Get.toNamed(Routers.departmentInfo,arguments: {'depart':target});
          break;
        case SpaceEnum.outAgency:
          Get.toNamed(Routers.outAgencyInfo,arguments: {'group':target});
          break;
        case SpaceEnum.stationSetting:
          Get.toNamed(Routers.stationInfo,arguments: {'station':target});
          break;
        case SpaceEnum.personGroup:
        case SpaceEnum.companyCohort:
          Get.toNamed(Routers.cohortInfo,arguments: {'cohort':target});
          break;
      }
    }else{
      switch (state.standardEnum) {
        case StandardEnum.permission:
          Get.toNamed(Routers.permissionInfo,
              arguments: {"authority": iAuthority});
          break;
        case StandardEnum.classCriteria:
          Get.toNamed(Routers.classificationInfo,
              arguments: {"species": species});
          break;
      }
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

