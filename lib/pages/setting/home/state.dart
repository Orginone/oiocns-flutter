import 'package:get/get.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_get_breadcrumb_nav_state.dart';

class SettingCenterState extends BaseBreadcrumbNavState {
  SettingController get settingCtrl => Get.find<SettingController>();
  late List<BaseBreadcrumbNavModel> spaces;

  SettingCenterState(){
    spaces = [];
    var joinedCompanies = settingCtrl.provider.user?.companys;
    spaces.add(BaseBreadcrumbNavModel(
        name: settingCtrl.provider.user?.metadata.name ?? "",
        id: settingCtrl.provider.user?.metadata.id ?? "",
        image: settingCtrl.provider.user?.metadata.avatarThumbnail(),
        source: settingCtrl.provider.user,
        children: []));
    for (var element in joinedCompanies ?? []) {
      spaces.add(BaseBreadcrumbNavModel(
          name: element.metadata.name,
          id: element.metadata.id,
          image: element.metadata.avatarThumbnail(),
          source: element,
          children: []));
    }
    title = "设置";
  }
}
