import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_controller.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/dart/core/target/team/company.dart';
import 'package:orginone/pages/setting/config.dart';
import 'package:orginone/pages/setting/dialog.dart';
import 'package:orginone/pages/setting/setting_sub_page/logic.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/toast_utils.dart';
import 'package:orginone/widget/loading_dialog.dart';

import 'state.dart';

class SettingCenterController
    extends BaseBreadcrumbNavController<SettingCenterState> {
  @override
  final SettingCenterState state = SettingCenterState();

  SettingSubController get sub => Get.find(tag: 'setting_all');
  @override
  void onReady() async {
    super.onReady();

    if (state.isRootDir && Get.arguments?['data'] == null) {
      LoadingDialog.showLoading(context);
      await loadUserSetting(state.model);
      await loadCompanySetting(state.model);
      state.model.refresh();
      LoadingDialog.dismiss(context);
    }
  }

  void onNextLv(SettingNavModel model) {
    if (model.children.isEmpty) {
      jumpDetails(model);
    } else {
      Get.toNamed(Routers.settingCenter,
          preventDuplicates: false, arguments: {"data": model});
    }
  }

  void jumpDetails(SettingNavModel model) {
    switch (model.spaceEnum) {
      case SpaceEnum.departments:
        Get.toNamed(Routers.departmentInfo,
            arguments: {'depart': model.source});
        break;
      case SpaceEnum.groups:
        Get.toNamed(Routers.outAgencyInfo, arguments: {'group': model.source});
        break;
      case SpaceEnum.cohorts:
        Get.toNamed(Routers.cohortInfo, arguments: {'cohort': model.source});
        break;
      case SpaceEnum.species:
      case SpaceEnum.applications:
      case SpaceEnum.form:
      case SpaceEnum.person:
        Get.toNamed(Routers.classificationInfo, arguments: {"data": model});
        break;
      case SpaceEnum.file:
        Routers.jumpFile(file: model.source!.shareInfo(), type: "setting");
        break;
      case SpaceEnum.user:
        Get.toNamed(Routers.userInfo);
        break;
      case SpaceEnum.company:
        Get.toNamed(Routers.companyInfo, arguments: {"company": model.space});
        break;
      case SpaceEnum.property:
        break;
      default:
        Get.toNamed(Routers.settingCenter,
            preventDuplicates: false, arguments: {"data": model});
        break;
    }
  }

  void updateInfo(PopupMenuKey key, SettingNavModel item) async {
    switch (item.spaceEnum) {
      case SpaceEnum.directory:
        createDir(item, isEdit: true, callback: () {
          state.model.refresh();
          if (item == state.model.value) {
            updateNav();
            if (state.isSettingSubPage) {
              sub.state.nav.refresh();
            }
          }
        });
        break;
      case SpaceEnum.species:
        createSpecies(item, item.source.metadata.typeName, isEdit: true,
            callback: ([nav]) {
          state.model.refresh();
          if (item == state.model.value) {
            updateNav();
            if (state.isSettingSubPage) {
              sub.state.nav.refresh();
            }
          }
        });
        break;
      case SpaceEnum.property:
        createAttr(item, isEdit: true, callback: ([nav]) {
          state.model.refresh();
          if (item == state.model.value) {
            updateNav();
            if (state.isSettingSubPage) {
              sub.state.nav.refresh();
            }
          }
        });
        break;
      case SpaceEnum.applications:
        createApplication(item, isEdit: true, callback: ([nav]) {
          state.model.refresh();
          if (item == state.model.value) {
            updateNav();
            if (state.isSettingSubPage) {
              sub.state.nav.refresh();
            }
          }
        });
        break;
      case SpaceEnum.form:
        createSpecies(item, '分类', isEdit: true, callback: ([nav]) {
          state.model.refresh();
          if (item == state.model.value) {
            updateNav();
            if (state.isSettingSubPage) {
              sub.state.nav.refresh();
            }
          }
        });
        break;
      case SpaceEnum.user:
      case SpaceEnum.company:
      case SpaceEnum.person:
      case SpaceEnum.departments:
      case SpaceEnum.groups:
      case SpaceEnum.cohorts:
        createTarget(key, item, isEdit: true, callback: ([nav]) {
          state.model.refresh();
          if (item == state.model.value) {
            updateNav();
            if (state.isSettingSubPage) {
              sub.state.nav.refresh();
            }
          }
        });
        break;
      default:
    }
  }

  void operation(PopupMenuKey key, SettingNavModel item) {
    switch (key) {
      case PopupMenuKey.createDir:
        createDir(item, callback: () {
          state.model.refresh();
        });
        break;
      case PopupMenuKey.createApplication:
        createApplication(item, callback: ([nav]) {
          if (item.spaceEnum != SpaceEnum.user &&
              item.spaceEnum != SpaceEnum.company) {
            item.children.add(nav!);
          } else {
            item.children[0].children.add(nav!);
          }
        });
        break;
      case PopupMenuKey.createSpecies:
        createSpecies(item, '分类', callback: ([nav]) {
          state.model.refresh();
        });
        break;
      case PopupMenuKey.createDict:
        createSpecies(item, '字典', callback: ([nav]) {
          state.model.refresh();
        });
        break;
      case PopupMenuKey.createAttr:
        createAttr(item, callback: ([nav]) {
          state.model.refresh();
        });
        break;
      case PopupMenuKey.createThing:
        createSpecies(item, '实体配置', callback: ([nav]) {
          state.model.refresh();
        });
        break;
      case PopupMenuKey.createWork:
        createSpecies(item, '事项配置', callback: ([nav]) {
          state.model.refresh();
        });
        break;
      case PopupMenuKey.createDepartment:
      case PopupMenuKey.createStation:
      case PopupMenuKey.createGroup:
      case PopupMenuKey.createCohort:
      case PopupMenuKey.createCompany:
        createTarget(key, item, callback: ([nav]) {
          if (key == PopupMenuKey.createCompany) {
            state.model.value!.children.add(nav!);
          } else {
            item.children.add(nav!);
          }
          state.model.refresh();
        });
        break;
      case PopupMenuKey.updateInfo:
        updateInfo(key, item);
        break;
      case PopupMenuKey.rename:
        rename(item, callback: () {
          state.model.refresh();
          if (item == state.model.value) {
            updateNav();
            if (state.isSettingSubPage) {
              sub.state.nav.refresh();
            }
          }
        });
        break;
      case PopupMenuKey.delete:
        delete(item, callback: () {
          state.model.value!.children.remove(item);
          state.model.refresh();
        });
        break;
      case PopupMenuKey.upload:
        uploadFile(item, callback: ([nav]) {
          state.model.refresh();
        });
        break;
      case PopupMenuKey.shareQr:
        shareQr(item);
        break;
      case PopupMenuKey.openChat:
        openChat(item);
        break;
      case PopupMenuKey.permission:
        break;
      case PopupMenuKey.addPerson:
        showSearchDialog(Get.context!, TargetType.person,
            title: "邀请成员", hint: "请输入用户的账号", onSelected: (targets) async {
          if (targets.isNotEmpty) {
            bool success = await state.model.value!.space!.applyJoin(targets);
            if (success) {
              ToastUtils.showMsg(msg: "发送申请成功");
            }
          }
        });
        break;
      case PopupMenuKey.role:
        Get.toNamed(Routers.roleSettings,
            arguments: {"target": state.model.value!.space});
        break;
      case PopupMenuKey.station:
        Get.toNamed(Routers.stationInfo, arguments: {
          "station": (state.model.value!.space as Company).stations[0]
        });
        break;
      default:
    }
  }

  @override
  void onTopPopupMenuSelected(PopupMenuKey key) {
    operation(key, state.model.value!);
  }
}
