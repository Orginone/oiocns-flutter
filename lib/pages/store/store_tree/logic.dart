import 'package:get/get.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_controller.dart';
import 'package:orginone/dart/core/target/base/belong.dart';
import 'package:orginone/dart/core/target/team/company.dart';
import 'package:orginone/dart/core/thing/form.dart';
import 'package:orginone/dart/core/thing/species.dart';
import 'package:orginone/pages/store/config.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/widget/loading_dialog.dart';

import 'state.dart';

class StoreTreeController extends BaseBreadcrumbNavController<StoreTreeState> {
  final StoreTreeState state = StoreTreeState();



  Future<void> loadUserSetting() async {
    var user = state.model.value!.children[0];
    List<StoreTreeNav> function = [
      StoreTreeNav(
        name: "个人文件",
        space: user.space,
        spaceEnum: SpaceEnum.directory,
        children: await loadFile(user.space!.directory.files,user.space!),
      ),
    ];

    function.addAll(await loadDir(user.space!.directory.children, user.space!));
    function.addAll(await loadCohorts(user.space!.cohorts, user.space!));
    user.children = function;
  }

  Future<void> loadCompanySetting() async {
    for (int i = 1; i < state.model.value!.children.length; i++) {
      var company = state.model.value!.children[i];
      List<StoreTreeNav> function = [
        StoreTreeNav(
          name: "单位文件",
          space: company.space,
          spaceEnum: SpaceEnum.directory,
          children: await loadFile(company.space!.directory.files,company.space!),
        ),
      ];
      function.addAll(
          await loadDir(company.space!.directory.children, company.space!));
      function.addAll(await loadTargets(
          (company.space!.targets.where(
                  (element) => element.isMyChat && element.id != company.id))
              .toList(),
          company.space!));
      function.addAll(
          await loadGroup((company.space! as Company).groups, company.space!));
      function.addAll(await loadCohorts(company.space!.cohorts, company.space!));
      company.children.addAll(function);
    }
  }


  @override
  void onReady() async{
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


  void jumpDetails(StoreTreeNav nav) {
    switch (nav.spaceEnum) {
      case SpaceEnum.departments:
        Get.toNamed(Routers.departmentInfo,
            arguments: {'depart': nav.source});
        break;
      case SpaceEnum.groups:
        Get.toNamed(Routers.outAgencyInfo, arguments: {'group': nav.source});
        break;
      case SpaceEnum.cohorts:
        Get.toNamed(Routers.cohortInfo, arguments: {'cohort': nav.source});
        break;
      case SpaceEnum.user:
        Get.toNamed(Routers.userInfo);
        break;
      case SpaceEnum.company:
        Get.toNamed(Routers.companyInfo, arguments: {"company": nav.space});
        break;
      default:
        onNext(nav);
        break;
    }
  }

  void jumpThing(StoreTreeNav nav) {
    Get.toNamed(Routers.thing, arguments: {
      'form': nav.form??nav.source,
      "belongId": nav.space!.id
    });
  }

  void jumpFile(StoreTreeNav nav) {
    Get.toNamed(Routers.messageFile, arguments: {"file":nav.source!.shareInfo(),"type":"store"});
  }

  void onNext(StoreTreeNav nav) {
    if (nav.source != null && nav.children.isEmpty) {
      if(nav.source.metadata.typeName.contains("配置") || nav.source.metadata.typeName == "分类项"){
        jumpThing(nav);
      } else if(nav.spaceEnum == SpaceEnum.file){
        jumpFile(nav);
      } else {
        Get.toNamed(Routers.storeTree,
            preventDuplicates: false, arguments: {'data': nav});
      }
    } else {
      Get.toNamed(Routers.storeTree,
          preventDuplicates: false, arguments: {'data': nav});
    }
  }

  void operation(PopupMenuKey key, StoreTreeNav item) {
    switch(key){
      case PopupMenuKey.shareQr:
        // TODO: Handle this case.
        break;
      case PopupMenuKey.setCommon:
        // TODO: Handle this case.
        break;
      case PopupMenuKey.removeCommon:
        // TODO: Handle this case.
        break;
    }
  }
}
