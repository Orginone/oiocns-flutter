import 'package:get/get.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_get_breadcrumb_nav_state.dart';
import 'package:orginone/dart/core/target/base/belong.dart';

class StoreTreeState extends BaseBreadcrumbNavState<StoreTreeNav> {
  SettingController get settingCtrl => Get.find<SettingController>();

  StoreTreeState() {
    model.value = Get.arguments?['data'];

    if (model.value == null) {
      var joinedCompanies = settingCtrl.user.companys;

      List<StoreTreeNav> organization = [];
      for (var value in joinedCompanies) {
        organization.add(
          StoreTreeNav(
            name: value.metadata.name ?? "",
            id: value.metadata.id!,
            space: value,
            children: [],
            image: value.metadata.avatarThumbnail(),
          ),
        );
      }
      model.value = StoreTreeNav(
        name: HomeEnum.store.label,
        children: [
          StoreTreeNav(
            name: settingCtrl.provider.user?.metadata.name ?? "",
            id: settingCtrl.provider.user?.metadata.id ?? "",
            image: settingCtrl.provider.user?.metadata.avatarThumbnail(),
            children: [],
            space: settingCtrl.provider.user,
          ),
          ...organization
        ],
      );
    }

    title = model.value?.name??"";
  }
}

class StoreTreeNav extends BaseBreadcrumbNavModel<StoreTreeNav> {
  IBelong? space;
  StoreTreeNav(
      {super.id = '',
      super.name = '',
      required List<StoreTreeNav> children,
      super.image,
      super.source,
      this.space,}) {
    this.children = children;
  }
}

