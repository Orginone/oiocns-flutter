import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/pages/setting/config.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/department_management.dart';
import 'package:orginone/util/setting_management.dart';
import 'package:orginone/util/toast_utils.dart';

import '../../../../dart/core/getx/base_controller.dart';
import '../../dialog.dart';
import 'state.dart';

class RelationController extends BaseController<RelationState> {
  final RelationState state = RelationState();

  SettingController get setting => Get.find<SettingController>();

  void nextLvForEnum(
      {CompanySpaceEnum? companySpaceEnum, UserSpaceEnum? userSpaceEnum}) {
    if (companySpaceEnum != null) {
      if (companySpaceEnum != CompanySpaceEnum.company) {
        Get.toNamed(Routers.relationGroup,
            arguments: {"companySpaceEnum": companySpaceEnum, "head": "关系"});
      } else {
        Get.toNamed(Routers.companyInfo);
      }
    }

    if (userSpaceEnum != null) {
      if (userSpaceEnum == UserSpaceEnum.personGroup) {
        Get.toNamed(Routers.relationGroup,
            arguments: {"userSpaceEnum": userSpaceEnum, "head": "关系"});
      } else {
        Get.toNamed(Routers.userInfo);
      }
    }
  }

  void createOrganization(
      {CompanySpaceEnum? companySpaceEnum, UserSpaceEnum? userSpaceEnum}) {
    showCreateOrganizationDialog(
        context,
        getTargetType(
            companySpaceEnum: companySpaceEnum, userSpaceEnum: userSpaceEnum),
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
        await reload(
            companySpaceEnum: companySpaceEnum, userSpaceEnum: userSpaceEnum);
        ToastUtils.showMsg(msg: "创建成功");
      } else {
        ToastUtils.showMsg(msg: "创建失败");
      }
    });
  }

  void editOrganization(
      {CompanySpaceEnum? companySpaceEnum, UserSpaceEnum? userSpaceEnum}) {
    showCreateOrganizationDialog(
        context,
        getTargetType(
            companySpaceEnum: companySpaceEnum, userSpaceEnum: userSpaceEnum),
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
      await reload(
          companySpaceEnum: companySpaceEnum, userSpaceEnum: userSpaceEnum);
      ToastUtils.showMsg(msg: "修改成功");
    });
  }

  List<TargetType> getTargetType(
      {CompanySpaceEnum? companySpaceEnum, UserSpaceEnum? userSpaceEnum}) {
    List<TargetType> targetType = [];
    if (companySpaceEnum != null) {
      switch (companySpaceEnum) {
        case CompanySpaceEnum.company:
        case CompanySpaceEnum.innerAgency:
          targetType.addAll(setting.space.subTeamTypes);
          break;
        case CompanySpaceEnum.outAgency:
          targetType.add(TargetType.group);
          break;
        case CompanySpaceEnum.stationSetting:
          targetType.add(TargetType.station);
          break;
        case CompanySpaceEnum.companyCohort:
          targetType.add(TargetType.cohort);
          break;
      }
    }
    if (userSpaceEnum != null) {
      switch (userSpaceEnum) {
        case UserSpaceEnum.personInfo:
          targetType.add(TargetType.person);
          break;
        case UserSpaceEnum.personGroup:
          targetType.add(TargetType.cohort);
          break;
      }
    }
    return targetType;
  }

  Future<void> reload(
      {CompanySpaceEnum? companySpaceEnum,
      UserSpaceEnum? userSpaceEnum}) async {
    if (companySpaceEnum != null) {
      switch (companySpaceEnum) {
        case CompanySpaceEnum.company:
          // TODO: Handle this case.
          break;
        case CompanySpaceEnum.innerAgency:
          await DepartmentManagement().initDepartment();
          break;
        case CompanySpaceEnum.outAgency:
          await SettingManagement().initGroup();
          break;
        case CompanySpaceEnum.stationSetting:
          await SettingManagement().initStations();
          break;
        case CompanySpaceEnum.companyCohort:
          await SettingManagement().initCohorts();
          break;
      }
    }
    if (userSpaceEnum != null) {
      switch (userSpaceEnum) {
        case UserSpaceEnum.personInfo:
          // TODO: Handle this case.
          break;
        case UserSpaceEnum.personGroup:
          await SettingManagement().initCohorts();
          break;
      }
    }
  }
}
