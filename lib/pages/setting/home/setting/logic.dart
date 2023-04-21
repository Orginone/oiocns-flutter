import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_controller.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_get_breadcrumb_nav_state.dart';
import 'package:orginone/pages/setting/config.dart';
import 'package:orginone/pages/setting/dialog.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/toast_utils.dart';
import 'state.dart';

class SettingFunctionController extends BaseBreadcrumbNavController<SettingFunctionState> {
 final SettingFunctionState state = SettingFunctionState();


 void nextLvForSpaceEnum(SettingFunctionBreadcrumbNavModel model) {
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
      case SpaceEnum.dynamic:
        Get.toNamed(
          Routers.dynamic,
        );
        break;
      case SpaceEnum.mark:
        Get.toNamed(
          Routers.mark,
        );
        break;
      case SpaceEnum.standardSettings:
        List<SettingFunctionBreadcrumbNavModel> data = [];
        for (var element in StandardEnum.values) {
          data.add(SettingFunctionBreadcrumbNavModel(name: element.label,standardEnum: element, space: state.space));
        }
        model.children = data;
        Get.toNamed(Routers.settingFunction,arguments: {'data': model},preventDuplicates: false);
        break;
      default:
        Get.toNamed(Routers.relationGroup, arguments: {
          "data":model,
        });
        break;
    }
  }

  void createOrganization(BaseBreadcrumbNavModel model) {
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
          teamRemark: remark,
          avatar: '',
          belongId: '');

      var data = await state.space.create(model);
      if (data != null) {
        ToastUtils.showMsg(msg: "创建成功");
      } else {
        ToastUtils.showMsg(msg: "创建失败");
      }
    });
 }

 void editOrganization(BaseBreadcrumbNavModel model) {
  showCreateOrganizationDialog(
      context, getTargetType(model),
        name: state.space.teamName,
        nickName: state.space.name,
        code: state.space.target.code,
        remark: state.space.target.team?.remark ?? "",
        identify: state.space.target.team?.code ?? "",
        type: TargetType.getType(state.space.typeName), callBack: (String name,
            String code,
            String nickName,
            String identify,
            String remark,
            TargetType type) async {
      await state.space.update(TargetModel(
          id: state.space.id,
          name: nickName,
          code: code,
          typeName: type.label,
          avatar: state.space.target.avatar,
          belongId: state.space.target.belongId,
          teamName: name,
          teamCode: code,
          teamRemark: remark));
      ToastUtils.showMsg(msg: "修改成功");
    });
 }

 List<TargetType> getTargetType(BaseBreadcrumbNavModel model) {
  List<TargetType> targetType = [];
  switch (model.source) {
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

}
