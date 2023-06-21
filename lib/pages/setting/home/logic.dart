import 'package:get/get.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_controller.dart';
import 'package:orginone/dart/core/target/team/company.dart';
import 'package:orginone/main.dart';
import 'package:orginone/pages/setting/config.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/hive_utils.dart';
import 'package:orginone/util/local_store.dart';
import 'package:orginone/widget/loading_dialog.dart';

import 'state.dart';

class SettingCenterController
    extends BaseBreadcrumbNavController<SettingCenterState> {
  final SettingCenterState state = SettingCenterState();


  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
    if (state.isRootDir) {
      LoadingDialog.showLoading(context);
      await loadUserSetting();
      await loadCompanySetting();
      state.model.refresh();
      LoadingDialog.dismiss(context);
    }
  }

  void jumpInfo(SettingNavModel model) {
    if (settingCtrl.isUserSpace(model.space)) {
      Get.toNamed(Routers.userInfo);
    } else {
      Get.toNamed(Routers.companyInfo, arguments: {"company": model.space});
    }
  }

  void onHomeNextLv(SettingNavModel model) {
    Get.toNamed(Routers.settingCenter,
        preventDuplicates: false, arguments: {"data": model});
  }

  void onDetailsNextLv(SettingNavModel model) {
    if (model.children.isEmpty && model.source!=null) {
      jumpDetails(model);
    } else {
      Get.toNamed(Routers.settingCenter,
          preventDuplicates: false, arguments: {"data": model});
    }
  }

  void jumpLogin() async {
    LocalStore.clear();
    await HiveUtils.clean();
    Get.offAllNamed(Routers.login);
  }

  void jumpDetails(SettingNavModel model) {
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
      case SpaceEnum.directory:
        // TODO: Handle this case.
        break;
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
        // TODO: Handle this case.
        break;
    }
  }


  Future<void> loadUserSetting() async {
    var user = state.model.value!.children[4];
    List<SettingNavModel> function = [
      SettingNavModel(
        name: "个人文件",
        space: user.space,
        spaceEnum: SpaceEnum.departments,
        children: user.space!.directory.files.map((e){
          return SettingNavModel(
            name: e.filedata.name!,
            space: user.space,
            source: e,
            spaceEnum: SpaceEnum.file,
            image: e.shareInfo().thumbnail,
          );
        }).toList(),
      ),
      SettingNavModel(
        name: "我的好友",
        space: user.space,
        spaceEnum: SpaceEnum.cohorts,
        children: user.space!.members.map((e){
          return SettingNavModel(
            name: e.name!,
            space: user.space,
            source: e,
            spaceEnum: SpaceEnum.person,
            image: e.avatarThumbnail(),
          );
        }).toList(),
      ),
    ];

    function.addAll(await loadDir(user.space!.directory.children, user.space!));
    function.addAll(await loadCohorts(user.space!.cohorts, user.space!));
    user.children = function;
  }

  Future<void> loadCompanySetting() async {
    for(int i = 5;i<state.model.value!.children.length;i++){
      var company = state.model.value!.children[i];
      List<SettingNavModel> function = [
        SettingNavModel(
          name: "单位文件",
          space: company.space,
          spaceEnum: SpaceEnum.departments,
          children: company.space!.directory.files.map((e){
            return SettingNavModel(
              name: e.filedata.name!,
              space: company.space,
              source: e,
              spaceEnum: SpaceEnum.file,
              image: e.shareInfo().thumbnail,
            );
          }).toList(),
        ),
        SettingNavModel(
          name: "单位成员",
          space: company.space,
          spaceEnum: SpaceEnum.cohorts,
          children: company.space!.members.map((e){
            return SettingNavModel(
              name: e.name!,
              space: company.space,
              source: e,
              spaceEnum: SpaceEnum.person,
              image: e.avatarThumbnail(),
            );
          }).toList(),
        ),
      ];
      function.addAll(await loadDir(company.space!.directory.children, company.space!));
      function.addAll(await loadDepartment((company.space! as Company).departments, company.space!));
      function.addAll(await loadGroup((company.space! as Company).groups, company.space!));
      function.addAll(await loadCohorts(company.space!.cohorts, company.space!));
      company.children.addAll(function);
    }
  }
}
