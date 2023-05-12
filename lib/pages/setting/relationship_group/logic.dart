import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_controller.dart';
import 'package:orginone/dart/core/target/authority/authority.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/thing/base/species.dart';
import 'package:orginone/pages/setting/config.dart';
import 'package:orginone/pages/setting/dialog.dart';
import 'package:orginone/pages/setting/home/setting/state.dart';
import 'package:orginone/pages/setting/network.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/toast_utils.dart';

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
      state.model.refresh();
    } else {
      if (standardEnum == StandardEnum.dict) {
        await SettingNetWork.initDict(state.model.value!);
        state.model.refresh();
      }
    }
  }

  void loopSpecies(List<ISpeciesItem> species,SettingNavModel model){
    model.children = [];
    for (var value in species) {
      var child = SettingNavModel(
          space: model.space,
          spaceEnum: model.spaceEnum,
          source: value,
          standardEnum: model.standardEnum,
          name: value.metadata.name);
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
              remark: remark,
              icon: '',
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
              remark: remark,
              icon: '',
              belongId: item.target.belongId);
          await item.update(model);
        },
        code: item.target.code,
        name: item.teamName,
        nickName: item.name,
        identify: item.target.code ?? "",
        remark: item.target.remark ?? "",
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
      var dict =await item.source.updateDict(DictModel(name: name, public: true, code: code, remark: remark,id: item.source.id));
      if(dict!=null){
        ToastUtils.showMsg(msg: "更新成功");
        item.source.name = name;
        item.source.code = code;
        item.source.remark = remark;
        item.name = name;
        state.model.refresh();
      }
    },name: item.source.name,code: item.source.code,remark: item.source.remark??"");
  }

  void removeDict(SettingNavModel item) async{
    bool success = await item.source.deleteDict(item.source.id);
    if(success){
      ToastUtils.showMsg(msg: "删除成功");
      state.model.value!.children.remove(item);
      state.model.refresh();
    }
  }

  void createAuth(SettingNavModel item) async{
    SettingController settingController = Get.find();
    List<ITarget> targets = await settingController.getTeamTree(item.space);
    showCreateAuthDialog(context, getAllTarget(targets), target: item.space,
        callBack: (name, code, target, isPublic, remark) async {
      var model = AuthorityModel();
      model.name = name;
      model.code = code;
      model.public = isPublic;
      model.remark = remark;
      model.shareId = item.source.belongId;
      IAuthority? result = await item.source.create(model);
      if (result != null) {
        ToastUtils.showMsg(msg: "创建成功");
        item.children.add(SettingNavModel(
          space: state.model.value!.space,
          image: result.shareInfo.avatar?.shareLink,
          name: result.metadata.name??"",
          source: result,
          standardEnum: StandardEnum.permission,
        ));
        state.model.refresh();
      }
    });
  }

  void editAuth(SettingNavModel item) async{
    SettingController settingController = Get.find();
    List<ITarget> targets =  await settingController.getTeamTree(item.space);
    showCreateAuthDialog(context,getAllTarget(targets), target: getAllTarget(targets).firstWhere((element) => element.metadata.name == item.source.target.belong.name),callBack: (name,code,target,isPublic,remark) async{
      var model = AuthorityModel();
      model.name = name;
      model.code = code;
      model.public = isPublic;
      model.remark = remark;
      model.shareId = item.source.belongId;
      IAuthority? result = await item.source.update(model);
      if(result!=null){
        ToastUtils.showMsg(msg: "修改成功");
        item.source.target.name = name;
        item.source.target.public = isPublic;
        item.source.target.remark = remark;
        item.source.target.code = code;
        item.name = name;
        state.model.refresh();
      }
    },isEdit: true,name:item.source.target.name,public: item.source.target.public,remark: item.source.target.remark,code: item.source.target.code);
  }

  void removeAuth(SettingNavModel item) async{
    ResultType result = await item.source.delete();
    if(result.success){
      ToastUtils.showMsg(msg: "删除成功");
      state.model.value!.children.remove(item);
      state.model.refresh();
    }
  }
}

