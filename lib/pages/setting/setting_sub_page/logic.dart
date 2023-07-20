import 'package:get/get.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/getx/base_list_controller.dart';
import 'package:orginone/main.dart';
import 'package:orginone/pages/setting/home/state.dart';
import 'package:orginone/routers.dart';

import '../config.dart';
import 'state.dart';

class SettingSubController extends BaseListController<SettingSubState> {
 final SettingSubState state = SettingSubState();

 late String type;

 SettingSubController(this.type);



 @override
  void onInit() async{
    // TODO: implement onInit
    super.onInit();
    if(type == 'all'){
     var joinedCompanies = settingCtrl.provider.user?.companys;
     state.nav.value = SettingNavModel(name: "设置", children: [
      SettingNavModel(
       name: settingCtrl.provider.user?.metadata.name ?? "",
       id: settingCtrl.provider.user?.metadata.id ?? "",
       image: settingCtrl.provider.user?.metadata.avatarThumbnail(),
       children: [],
       space: settingCtrl.provider.user,
       spaceEnum: SpaceEnum.user,
      ),
      ...joinedCompanies
                ?.map((element) => SettingNavModel(
                    name: element.metadata.name!,
                    id: element.metadata.id!,
                    image: element.metadata.avatarThumbnail(),
                    space: element,
                    spaceEnum: SpaceEnum.company,
                    children: []))
                .toList() ??
            [],
      ]);
      await loadUserSetting(state.nav);
      await loadCompanySetting(state.nav);
      state.nav.refresh();
    }
    loadSuccess();
  }

  void onNextLv(SettingNavModel model) {
  if (model.children.isEmpty && model.spaceEnum!=SpaceEnum.directory) {
   jumpDetails(model);
  } else {
   Get.toNamed(Routers.settingCenter,
       preventDuplicates: false, arguments: {"data": model,"isSettingSubPage":true});
  }
 }

 void jumpDetails(SettingNavModel model) {
  switch (model.spaceEnum) {
   case SpaceEnum.user:
    Get.toNamed(Routers.userInfo);
    break;
   case SpaceEnum.company:
    Get.toNamed(Routers.companyInfo, arguments: {"company": model.space});
    break;
  }
 }
 void updateInfo(PopupMenuKey key, SettingNavModel item) async {
  switch (item.spaceEnum) {
   case SpaceEnum.user:
   case SpaceEnum.company:
   case SpaceEnum.person:
   case SpaceEnum.departments:
   case SpaceEnum.groups:
      case SpaceEnum.cohorts:
        createTarget(key, item, isEdit: true, callback: ([nav]) {
          state.nav.refresh();
        });
        break;
    }
 }

 void operation(PopupMenuKey key, SettingNavModel item) {
    switch (key) {
      case PopupMenuKey.createDir:
        createDir(item, callback: () {
          state.nav.refresh();
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
          state.nav.refresh();
          if (item.spaceEnum != SpaceEnum.user &&
              item.spaceEnum != SpaceEnum.company) {
            item.children.add(nav);
          } else {
            item.children[0].children.add(nav);
          }
          state.nav.refresh();
        });
        break;
      case PopupMenuKey.createSpecies:
        createSpecies(item, '分类', callback: ([nav]) {
          if (item.spaceEnum == SpaceEnum.user ||
              item.spaceEnum == SpaceEnum.company) {
            item.children[0].children.add(nav!);
          } else {
            item.children.add(nav!);
          }

          state.nav.refresh();
        });
        break;
      case PopupMenuKey.createDict:
        createSpecies(item, '字典', callback: ([nav]) {
          if (item.spaceEnum == SpaceEnum.user ||
              item.spaceEnum == SpaceEnum.company) {
            item.children[0].children.add(nav!);
          } else {
            item.children.add(nav!);
          }

          state.nav.refresh();
        });
        break;
      case PopupMenuKey.createAttr:
        createAttr(item, callback: ([nav]) {
          if (item.spaceEnum != SpaceEnum.user &&
              item.spaceEnum != SpaceEnum.company) {
            item.children.add(nav!);
          } else {
            item.children[0].children.add(nav!);
          }
          state.nav.refresh();
        });
        break;
      case PopupMenuKey.createThing:
        createSpecies(item, '实体配置', callback: ([nav]) {
          if (item.spaceEnum == SpaceEnum.user ||
              item.spaceEnum == SpaceEnum.company) {
            item.children[0].children.add(nav!);
          } else {
            item.children.add(nav!);
          }

          state.nav.refresh();
        });
        break;
      case PopupMenuKey.createWork:
        createSpecies(item, '事项配置', callback: ([nav]) {
          if (item.spaceEnum == SpaceEnum.user ||
              item.spaceEnum == SpaceEnum.company) {
            item.children[0].children.add(nav!);
          } else {
            item.children.add(nav!);
          }

          state.nav.refresh();
        });
        break;
      case PopupMenuKey.createDepartment:
      case PopupMenuKey.createStation:
   case PopupMenuKey.createGroup:
   case PopupMenuKey.createCohort:
      case PopupMenuKey.createCompany:
        createTarget(key, item, callback: ([nav]) {
          if (key == PopupMenuKey.createCompany) {
            state.nav.value!.children.add(nav!);
          } else {
            item.children.add(nav!);
          }
          state.nav.refresh();
        });
        break;
      case PopupMenuKey.updateInfo:
        updateInfo(key, item);
        break;
      case PopupMenuKey.upload:
        uploadFile(item, callback: ([nav]) {
          if (item.spaceEnum == SpaceEnum.directory) {
            item.children.add(nav!);
          } else {
            item.children[0].children.add(nav!);
          }
          state.nav.refresh();
        });
        break;
      case PopupMenuKey.shareQr:
        shareQr(item);
        break;
      case PopupMenuKey.openChat:
    openChat(item);
        break;
    }
 }

 @override
  void onReady() {
    // TODO: implement onReady
  }
  @override
  Future<void> loadData({bool isRefresh = false, bool isLoad = false}) async{

  }
}
