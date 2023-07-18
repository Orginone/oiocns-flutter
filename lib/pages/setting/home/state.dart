import 'dart:ui';

import 'package:get/get.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_get_breadcrumb_nav_state.dart';
import 'package:orginone/dart/core/target/base/belong.dart';
import 'package:orginone/main.dart';

class SettingCenterState extends BaseBreadcrumbNavState<SettingNavModel> {

  late bool isSettingSubPage;

  SettingCenterState() {
    model.value = Get.arguments?['data'];
    isSettingSubPage = Get.arguments?['isSettingSubPage']??false;
    if (model.value == null) {
      var joinedCompanies = settingCtrl.provider.user?.companys;
      model.value = SettingNavModel(name: "设置", children: [
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
    }

    title = model.value!.name;
  }
}



class SettingNavModel extends BaseBreadcrumbNavModel<SettingNavModel> {
  IBelong? space;
  SettingNavModel(
      {super.id = '',
        super.name = '',
        super.children = const [],
        super.source,
        super.image,
        super.spaceEnum,
        super.showPopup = true,
        super.onNext,
        this.space,
      });
}
