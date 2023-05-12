import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_controller.dart';
import 'package:orginone/dart/core/target/authority/authority.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/pages/setting/config.dart';
import 'package:orginone/pages/setting/dialog.dart';
import 'package:orginone/pages/setting/network.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/toast_utils.dart';

import 'state.dart';

class SettingFunctionController extends BaseBreadcrumbNavController<SettingFunctionState> {
  final SettingFunctionState state = SettingFunctionState();

  void nextLvForSpaceEnum(SettingNavModel model) async {
    if (model.spaceEnum != null) {
      switch (model.spaceEnum) {
        case SpaceEnum.cardbag:
          Get.toNamed(
            Routers.cardbag,
          );
          break;
        case SpaceEnum.security:
          Get.toNamed(
            Routers.security,
          );
          break;
        case SpaceEnum.gateway:
          Get.toNamed(
            Routers.security,
          );
          break;
        case SpaceEnum.theme:
          Get.toNamed(
            Routers.security,
          );
          break;
        case SpaceEnum.standardSettings:
          List<SettingNavModel> data = [];
          var nav = await SettingNetWork.initAuthority(state.model.value!);
          if (nav != null) {
            data.add(nav);
          }
          data.add(SettingNavModel(
              name: StandardEnum.dict.label,
              standardEnum: StandardEnum.dict,
              space: state.space));
          data.addAll(await SettingNetWork.initSpecies(state.model.value!));
          model.children = data;
          Get.toNamed(Routers.settingFunction,
              arguments: {'data': model}, preventDuplicates: false);
          break;
        default:
          Get.toNamed(Routers.relationGroup, arguments: {
            "data": model,
          });
          break;
      }
    } else if (model.standardEnum != null) {
      if(model.children.isEmpty){
        if(model.standardEnum == StandardEnum.permission){
          Get.toNamed(Routers.permissionInfo,
              arguments: {"authority": model.source});
        }else{
          Get.toNamed(Routers.classificationInfo,
              arguments: {"data": model});
        }

      }else{
        Get.toNamed(Routers.relationGroup, arguments: {
          "data": model,
        });
      }
    }
  }

  void createOrganization(SettingNavModel model) {
    showCreateOrganizationDialog(
        context,
        getTargetType(model),
        callBack: (String name, String code, String nickName, String identify,
            String remark, TargetType type) async {
          var model = TargetModel(
              name: nickName,
              code: code,
              typeName: type.label,
              teamName: name,
          teamCode: code,
          remark: remark,
          icon: '',
          belongId: '');

      var data = await state.space.createTarget(model);
      if (data != null) {
        ToastUtils.showMsg(msg: "创建成功");
      } else {
        ToastUtils.showMsg(msg: "创建失败");
      }
    });
 }

 void editOrganization(SettingNavModel model) {
   showCreateOrganizationDialog(
       context, getTargetType(model),
       name: state.space.metadata.name,
       nickName: state.space.metadata.name,
       code: state.space.metadata.code,
       remark: state.space.metadata.remark ?? "",
       identify: state.space.metadata.code,
       type: TargetType.getType(state.space.metadata.typeName),
       callBack: (String name,
           String code,
           String nickName,
            String identify,
            String remark,
            TargetType type) async {
      await state.space.update(TargetModel(
          id: state.space.metadata.id,
          name: nickName,
          code: code,
          typeName: type.label,
          icon: state.space.metadata.icon,
          belongId: state.space.metadata.belongId,
          teamName: name,
          teamCode: code,
          remark: remark));
      ToastUtils.showMsg(msg: "修改成功");
    });
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

 List<TargetType> getTargetType(SettingNavModel model) {
   List<TargetType> targetType = [];
   switch (model.spaceEnum) {
     case SpaceEnum.innerAgency:
       targetType.addAll(model.space.memberTypes);
       break;
     case SpaceEnum.outAgency:
       targetType.add(TargetType.group);
       break;
     case SpaceEnum.stationSetting:
       targetType.add(TargetType.station);
       break;
     case SpaceEnum.externalCohort:
       targetType.add(TargetType.cohort);
       break;
     case SpaceEnum.personGroup:
       targetType.add(TargetType.cohort);
       break;
   }
   return targetType;
 }

 void createDict(SettingNavModel item) {
   showCreateDictDialog(context,onCreate: (name,code,remark){
     var dict = item.space.createDict(DictModel(name: name, public: true, code: code, remark: remark));
     if(dict!=null){
       ToastUtils.showMsg(msg: "新建成功");
     }
   });
 }


}
