import 'package:get/get.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_get_breadcrumb_nav_state.dart';
import 'package:orginone/dart/core/target/base/belong.dart';
import 'package:orginone/main.dart';
import 'package:orginone/pages/setting/config.dart';

class SettingCenterState extends BaseBreadcrumbNavState<SettingNavModel> {

  SettingCenterState() {
    model.value = Get.arguments?['data'];

    if (model.value == null) {
      var joinedCompanies = settingCtrl.provider.user?.companys;
      model.value = SettingNavModel(name: "设置", children: [
        SettingNavModel(
            name: SpaceEnum.security.label,
            spaceEnum: SpaceEnum.security,
            space: settingCtrl.provider.user),
        SettingNavModel(
            name: SpaceEnum.cardbag.label,
            spaceEnum: SpaceEnum.cardbag,
            space: settingCtrl.provider.user),
        SettingNavModel(
            name: SpaceEnum.gateway.label,
            spaceEnum: SpaceEnum.gateway,
            space: settingCtrl.provider.user),
        SettingNavModel(
            name: SpaceEnum.theme.label,
            spaceEnum: SpaceEnum.theme,
            space: settingCtrl.provider.user),
        SettingNavModel(
          name: settingCtrl.provider.user?.metadata.name ?? "",
          id: settingCtrl.provider.user?.metadata.id ?? "",
          image: settingCtrl.provider.user?.metadata.avatarThumbnail(),
          children: [],
          settingType: SettingType.personal,
          space: settingCtrl.provider.user,
        ),
        ...joinedCompanies
                ?.map((element) => SettingNavModel(
                    name: element.metadata.name!,
                    id: element.metadata.id!,
                    image: element.metadata.avatarThumbnail(),
                    space: element,
                    settingType: SettingType.organization,
                    children: []))
                .toList() ??
            [],
      ]);
    }

    title = model.value!.name;
  }
}



class SettingNavModel extends BaseBreadcrumbNavModel<SettingNavModel> {
  SpaceEnum? spaceEnum;
  IBelong? space;
  SettingType? settingType;
  SettingNavModel(
      {super.id = '',
        super.name = '',
        super.children = const [],
        super.source,
        super.image,
        this.spaceEnum,
        this.space,
        this.settingType,
      });
}
