import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_controller.dart';
import 'package:orginone/dart/core/target/authority/iauthority.dart';
import 'package:orginone/dart/core/target/company.dart';
import 'package:orginone/dart/core/target/itarget.dart';
import 'package:orginone/dart/core/thing/ispecies.dart';
import 'package:orginone/dart/core/thing/species.dart';
import 'package:orginone/pages/setting/config.dart';
import 'package:orginone/pages/setting/dialog.dart';
import 'package:orginone/pages/setting/home/setting/state.dart';
import 'package:orginone/pages/setting/network.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/common_tree_management.dart';
import 'package:orginone/util/department_management.dart';
import 'package:orginone/util/toast_utils.dart';

import '../../../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class RelationGroupController extends BaseBreadcrumbNavController<RelationGroupState> {
  final RelationGroupState state = RelationGroupState();


  @override
  void onReady() async{
    // TODO: implement onReady
    super.onReady();
    if(state.model.value!.children.isEmpty){
      await initData();
    }
  }


  Future<void> initData() async{
    var spaceEnum = state.model.value!.spaceEnum;
    var standardEnum = state.model.value!.standardEnum;
    if(!state.isStandard){
      switch (spaceEnum) {
        case SpaceEnum.innerAgency:
          await SettingNetWork.initDepartment(state.model.value!);
          break;
        case SpaceEnum.outAgency:
           await SettingNetWork.initGroup(state.model.value!);
          break;
        case SpaceEnum.stationSetting:
        await SettingNetWork.initStations(state.model.value!);
          break;
        case SpaceEnum.personGroup:
        case SpaceEnum.externalCohort:
           await SettingNetWork.initCohorts(state.model.value!);
          break;
      }
    } else {
      switch(standardEnum){
        case StandardEnum.permission:
         await SettingNetWork.initAuthority(state.model.value!);
          break;
        case StandardEnum.classCriteria:
          await SettingNetWork.initSpecies(state.model.value!);
          if(CommonTreeManagement().species!=null){
            loopSpecies([CommonTreeManagement().species!],state.model.value!);
          }
          break;
        case StandardEnum.dict:
          await SettingNetWork.initDict(state.model.value!);
          break;
        case StandardEnum.attribute:
          // TODO: Handle this case.
          break;
      }
    }
    state.model.refresh();
  }

  void loopSpecies(List<ISpeciesItem> species,SettingNavModel model){
    model.children = [];
    for (var value in species) {
      var child = SettingNavModel(
          space: model.space,
          spaceEnum: model.spaceEnum,
          source: value,
          standardEnum: model.standardEnum,
          name: value.name);
      if(value.children.isNotEmpty){
        loopSpecies(value.children,child);
      }
      model.children.add(child);
    }
  }

  void nextLv(SettingNavModel model) {
    if(model.children.isNotEmpty){
      Get.toNamed(Routers.relationGroup, arguments: {
        "data":model,
      },preventDuplicates: false);
    }else{
      onTap(model);
    }
  }


  void onTap(SettingNavModel model) {
    var spaceEnum = state.model.value!.spaceEnum;
    var standardEnum = state.model.value!.standardEnum;
    if(!state.isStandard){
      switch(spaceEnum){
        case SpaceEnum.innerAgency:
          Get.toNamed(Routers.departmentInfo,arguments: {'depart':model.source});
          break;
        case SpaceEnum.outAgency:
          Get.toNamed(Routers.outAgencyInfo,arguments: {'group':model.source});
          break;
        case SpaceEnum.stationSetting:
          Get.toNamed(Routers.stationInfo,arguments: {'station':model.source});
          break;
        case SpaceEnum.personGroup:
        case SpaceEnum.externalCohort:
          Get.toNamed(Routers.cohortInfo,arguments: {'cohort':model.source});
          break;
      }
    }else{
      switch (standardEnum) {
        case StandardEnum.permission:
          Get.toNamed(Routers.permissionInfo,
              arguments: {"authority": model.source});
          break;
        case StandardEnum.classCriteria:
          Get.toNamed(Routers.classificationInfo,
              arguments: {"data": model});
          break;
        case StandardEnum.dict:
          Get.toNamed(Routers.dictInfo,
              arguments: {"data": model});
          break;
        case StandardEnum.attribute:
          Get.toNamed(Routers.dictInfo,
              arguments: {"data": model});
          break;
      }
    }
  }

  void createGroup(dynamic item){
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
  }


  void editGroup(dynamic item) {
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
  }


  void removeGroup(dynamic item) async{
    bool success = await item.delete();
    if(success){
      state.model.value!.children.remove(item);
      state.model.refresh();
    }else{
      ToastUtils.showMsg(msg: "删除失败");
    }
  }

  void editDict(SettingNavModel item) {
    showCreateDictDialog(context,onCreate: (name,code,remark) async{
      var dict =await item.space.dict.updateDict(DictModel(name: name, public: true, code: code, remark: remark,id: item.source.id));
      if(dict!=null){
        ToastUtils.showMsg(msg: "更新成功");
        var index = state.model.value!.children.indexOf(item);
        var model = state.model.value!.children[index];
        model.source.name = name;
        model.source.code = code;
        model.source.remark = remark;
        model.name = name;
        state.model.refresh();
      }
    },name: item.source.name,code: item.source.code,remark: item.source.remark??"");
  }

  void removeDict(SettingNavModel item) async{
    bool success = await item.space.dict.deleteDict(item.source.id);
    if(success){
      ToastUtils.showMsg(msg: "删除成功");
      state.model.value!.children.remove(item);
      state.model.refresh();
    }
  }
}

