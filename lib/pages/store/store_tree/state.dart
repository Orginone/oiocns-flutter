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
            id: value.metadata.id,
            space: value,
            children: [],
            image: value.metadata.avatarThumbnail(),
            wareHouseType: WareHouseType.organization,
          ),
        );
      }
      model.value = StoreTreeNav(
        name: HomeEnum.store.label,
        children: [
          StoreTreeNav(
              name: WareHouseType.personal.label,
              wareHouseType: WareHouseType.personal,
              children: [
                StoreTreeNav(
                    name: PersonalEnum.file.label,
                    personalEnum: PersonalEnum.file,
                    children: [],
                    space: settingCtrl.user),
              ],
              space: settingCtrl.user),
          StoreTreeNav(
            children: organization,
            name: WareHouseType.organization.label,
            wareHouseType: WareHouseType.organization,
          ),
        ],
      );
    }

    title = model.value?.name??"";
  }
}

class StoreTreeNav extends BaseBreadcrumbNavModel<StoreTreeNav> {
  PersonalEnum? personalEnum;
  IBelong? space;
  SpeciesType? speciesType;
  WareHouseType? wareHouseType;
  StoreTreeNav(
      {super.id = '',
      super.name = '',
      required List<StoreTreeNav> children,
      super.image,
      super.source,
      this.personalEnum,
      this.space,
      this.speciesType,this.wareHouseType}) {
    this.children = children;
  }
}


enum WareHouseType {
  personal("个人"),
  target('目标用户'),
  organization("组织");
  final String label;
  const WareHouseType(this.label);
}

enum PersonalEnum {
  file("文件");

  final String label;

  const PersonalEnum(this.label);
}
