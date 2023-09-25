import 'package:get/get.dart';
import 'package:orginone/dart/controller/index.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_get_breadcrumb_nav_state.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/thing/form.dart';
import 'package:orginone/main.dart';

class StoreTreeState extends BaseBreadcrumbNavState<StoreTreeNav> {
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
            spaceEnum: SpaceEnum.company,
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
            spaceEnum: SpaceEnum.user,
          ),
          ...organization
        ],
      );
    }

    title = model.value?.name ?? "";
  }
}

class StoreTreeNav extends BaseBreadcrumbNavModel<StoreTreeNav> {
  ITarget? space;
  IForm? form;
  StoreTreeNav(
      {super.id = '',
      super.name = '',
      required List<StoreTreeNav> children,
      super.image,
      super.source,
      super.showPopup = true,
      super.onNext,
      this.space,
      this.form,
      super.spaceEnum}) {
    this.children = children;
  }
}
