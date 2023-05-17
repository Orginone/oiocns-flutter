import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_controller.dart';
import 'package:orginone/dart/core/target/authority/authority.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/thing/base/species.dart';
import 'package:orginone/pages/setting/config.dart';
import 'package:orginone/pages/setting/dialog.dart';
import 'package:orginone/pages/setting/network.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/toast_utils.dart';

import 'state.dart';

class SettingFunctionController extends BaseBreadcrumbNavController<SettingFunctionState> {
  final SettingFunctionState state = SettingFunctionState();

  SettingController settingController = Get.find();

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
          var species = SettingNavModel(
              name: StandardEnum.classCriteria.label,
              standardEnum: StandardEnum.classCriteria,
              space: state.space);
          await SettingNetWork.initSpecies(species);
          data.add(species);
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
      if (model.children.isEmpty && model.source != null) {
        if (model.standardEnum == StandardEnum.permission) {
          Get.toNamed(Routers.permissionInfo,
              arguments: {"authority": model.source});
        } else {
          Get.toNamed(Routers.classificationInfo, arguments: {"data": model});
        }
      } else {
        Get.toNamed(Routers.relationGroup, arguments: {
          "data": model,
        });
      }
    }
  }

  void createOrganization(SettingNavModel model, {bool isEdit = false}) {
    showCreateOrganizationDialog(context, getTargetType(model), callBack:
        (String name, String code, String nickName, String identify,
        String remark, TargetType type) async {
      var model = TargetModel(
        name: nickName,
        code: code,
        typeName: type.label,
        teamName: name,
        teamCode: code,
        remark: remark,
        icon: '',
      );

      if (isEdit) {
        model.icon = state.space.metadata.icon;
        model.belongId = state.space.metadata.belongId;
        model.id = state.space.metadata.id;
        var success = await state.space.update(model);
        if (success) {
          ToastUtils.showMsg(msg: "修改成功");
        }
      } else {
        var data = await state.space.createTarget(model);
        if (data != null) {
          ToastUtils.showMsg(msg: "创建成功");
        }
      }
    },
        isEdit: isEdit,
        name: isEdit ? state.space.metadata.name : "",
        nickName: isEdit ? state.space.metadata.name : "",
        code: isEdit ? state.space.metadata.code : "",
        remark: isEdit ? state.space.metadata.remark ?? "" : "",
        identify: isEdit ? state.space.metadata.code : "",
        type:
        isEdit ? TargetType.getType(state.space.metadata.typeName) : null);
  }

  void createAuth(SettingNavModel item) async {
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
              name: result.metadata.name ?? "",
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
    showCreateDictDialog(context, onCreate: (name, code, remark) async {
      // var dict = await item.space.createDict(
      //     DictModel(name: name, public: true, code: code, remark: remark));
      // if (dict != null) {
      //   ToastUtils.showMsg(msg: "新建成功");
      // }
    });
  }

  void createClassCriteria(SettingNavModel e) async {
    List<ISpeciesItem> species = [];
    for (var element in e.children) {
      if (element.source.speciesTypes.isNotEmpty) {
        species.add(element.source);
      }
    }
    IAuthority? authority = await e.space.loadSuperAuth();
    List<IAuthority> auth = [];
    if (authority != null) {
      auth.add(authority);
    }
    List<ITarget> targets = await settingController.getTeamTree(e.space);

    showClassCriteriaDialog(
        context, getAllTarget(targets), species, getAllAuthority(auth),
        callBack: (name, code, target, specie, auth, public, remark) async {
          var item = e.space.createSpecies(SpeciesModel(name: name,
              code: code,
              public: public,
              typeName:specie.metadata.typeName,
              shareId: target.metadata.id,
              authId: auth.metadata.id ?? "",
              remark: remark));

          if(item!=null){
            await SettingNetWork.initSpecies(e);
          }
        });
  }
}
