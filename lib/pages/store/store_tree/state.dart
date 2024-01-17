import 'package:get/get.dart';
import 'package:orginone/dart/controller/index.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_get_breadcrumb_nav_state.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/thing/standard/form.dart';
import 'package:orginone/main_bean.dart';

class StoreTreeState extends BaseBreadcrumbNavState<StoreTreeNav> {
  StoreTreeState() {
    model.value = Get.arguments is Map
        ? Get.arguments['data'] is StoreTreeNav
            ? Get.arguments['data']
            : null
        : null;

    ///返回的时候才会执行
    if (model.value == null) {
      var joinedCompanies = relationCtrl.user.companys;

      List<StoreTreeNav> organization = [];
      for (var value in joinedCompanies) {
        organization.add(
          StoreTreeNav(
            name: value.metadata.name ?? "",
            id: value.metadata.id,
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
            name: relationCtrl.provider.user.metadata.name ?? "",
            id: relationCtrl.provider.user.metadata.id ?? "",
            image: relationCtrl.provider.user.metadata.avatarThumbnail(),
            children: [],
            space: relationCtrl.provider.user,
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
