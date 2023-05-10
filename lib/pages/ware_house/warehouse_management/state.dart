


import 'package:get/get.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_get_breadcrumb_nav_state.dart';
import 'package:orginone/dart/core/target/base/belong.dart';

class WareHouseManagementState extends BaseBreadcrumbNavState{
  SettingController get settingCtrl => Get.find<SettingController>();

  WareHouseManagementState(){
    title = "仓库";
    model.value = Get.arguments?['data'];

     if(model.value == null){
       var joinedCompanies = settingCtrl.user.companys;

       List<WareHouseBreadcrumbNav> organization = [];
       for (var value in joinedCompanies) {
         organization.add(
           WareHouseBreadcrumbNav(
             name: value.metadata.name??"",
             id: value.metadata.id,
             space: value,
             wareHouseType: WareHouseType.organization,
             children: [
               ],
             image: value.metadata.avatarThumbnail(),
           ),
         );
       }
       model.value = WareHouseBreadcrumbNav(
         name: "仓库",
         children: [
           WareHouseBreadcrumbNav(
               name: WareHouseType.personal.label,
               children: [
                 WareHouseBreadcrumbNav(
                     name: PersonalEnum.application.label,
                     personalEnum: PersonalEnum.application, children: []),
                 WareHouseBreadcrumbNav(
                     name: PersonalEnum.file.label, personalEnum: PersonalEnum.file, children: []),
                 WareHouseBreadcrumbNav(
                     name: PersonalEnum.data.label, personalEnum: PersonalEnum.data, children: []),
               ],
               space: settingCtrl.user
           ),
           WareHouseBreadcrumbNav(
             name: WareHouseType.organization.label,
             children: organization,
           ),
         ],
       );
     }

    title = model.value!.name;
  }
}

class WareHouseBreadcrumbNav extends BaseBreadcrumbNavModel<WareHouseBreadcrumbNav> {
  PersonalEnum? personalEnum;
  IBelong? space;
  WareHouseType? wareHouseType;
  WareHouseBreadcrumbNav(
      {super.id = '',
        super.name = '',
        required List<WareHouseBreadcrumbNav> children,
        super.image,
        super.source,
        this.personalEnum,
        this.space,this.wareHouseType}){
    this.children = children;
  }
}


List<String> personalWork = [
  "应用",
  "文件",
  "数据",
];

enum WareHouseType {
  personal("个人"),
  organization("组织"),
  group("组");
  final String label;
  const WareHouseType(this.label);
}

enum PersonalEnum {
  application("应用"),
  file("文件"),
  data("数据");

  final String label;

  const PersonalEnum(this.label);
}
