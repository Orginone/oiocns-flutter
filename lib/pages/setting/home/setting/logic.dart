import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/pages/setting/config.dart';
import 'package:orginone/pages/setting/dialog.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/department_management.dart';
import 'package:orginone/util/setting_management.dart';
import 'package:orginone/util/toast_utils.dart';

import '../../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class SettingFunctionController extends BaseController<SettingFunctionState> {
 final SettingFunctionState state = SettingFunctionState();


 void nextLvForSpaceEnum(SpaceEnum spaceEnum) {
  Get.toNamed(Routers.relationGroup,
      arguments: {"spaceEnum": spaceEnum, "head": "关系"});
 }

 void createOrganization(SpaceEnum spaceEnum) {
  showCreateOrganizationDialog(
      context,
      getTargetType(spaceEnum),
      callBack: (String name, String code, String nickName, String identify,
          String remark, TargetType type) async {
       var model = TargetModel(
           name: nickName,
           code: code,
           typeName: type.label,
           teamName: name,
           teamCode: code,
           teamRemark: remark,
           avatar: '',
           belongId: '');

       var data = await setting.space.create(model);
       if (data != null) {
        await reload(spaceEnum);
        ToastUtils.showMsg(msg: "创建成功");
       } else {
        ToastUtils.showMsg(msg: "创建失败");
       }
      });
 }

 void editOrganization(SpaceEnum spaceEnum) {
  showCreateOrganizationDialog(
      context,
      getTargetType(spaceEnum),
      name: setting.space.teamName,
      nickName: setting.space.name,
      code: setting.space.target.code,
      remark: setting.space.target.team?.remark ?? "",
      identify: setting.space.target.team?.code ?? "",
      type: TargetType.getType(setting.space.typeName), callBack:
      (String name, String code, String nickName, String identify,
      String remark, TargetType type) async {
   await setting.space.update(TargetModel(
       id: setting.space.id,
       name: nickName,
       code: code,
       typeName: type.label,
       avatar: setting.space.target.avatar,
       belongId: setting.space.target.belongId,
       teamName: name,
       teamCode: code,
       teamRemark: remark));
   await reload(spaceEnum);
   ToastUtils.showMsg(msg: "修改成功");
  });
 }

 List<TargetType> getTargetType(SpaceEnum spaceEnum) {
  List<TargetType> targetType = [];
  switch (spaceEnum) {
   case SpaceEnum.innerAgency:
    targetType.addAll(setting.space.subTeamTypes);
    break;
   case SpaceEnum.outAgency:
    targetType.add(TargetType.group);
    break;
   case SpaceEnum.stationSetting:
    targetType.add(TargetType.station);
    break;
   case SpaceEnum.companyCohort:
    targetType.add(TargetType.cohort);
    break;
   case SpaceEnum.personGroup:
    targetType.add(TargetType.cohort);
    break;
  }
  return targetType;
 }

 Future<void> reload(SpaceEnum spaceEnum) async {
  switch (spaceEnum) {
   case SpaceEnum.innerAgency:
    await DepartmentManagement().initDepartment();
    break;
   case SpaceEnum.outAgency:
    await SettingManagement().initGroup();
    break;
   case SpaceEnum.stationSetting:
    await SettingManagement().initStations();
    break;
   case SpaceEnum.personGroup:
   case SpaceEnum.companyCohort:
    await SettingManagement().initCohorts();
    break;
  }
 }

  void nextLvForStandardEnum(StandardEnum standardEnum) {
   Get.toNamed(Routers.relationGroup,arguments: {"standardEnum":standardEnum,"head":"标准"});
  }
}
