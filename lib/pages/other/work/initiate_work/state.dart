import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_get_breadcrumb_nav_state.dart';

class InitiateWorkState extends BaseBreadcrumbNavState {
  SettingController get settingCtrl => Get.find<SettingController>();

  Map<String,List<WorkBreadcrumbNav>> work = {};

  WorkBreadcrumbNav? organizationWork;

  InitiateWorkState() {
    var joinedCompanies = settingCtrl.user!.joinedCompany;

    organizationWork = Get.arguments?['data'];
    if(organizationWork!=null){
      title = organizationWork!.name;
    }else{
      title = "发起办事";

      work['个人'] = [
        WorkBreadcrumbNav(
            name: WorkEnum.addFriends.label, source: WorkEnum.addFriends),
        WorkBreadcrumbNav(
            name: WorkEnum.addUnits.label, source: WorkEnum.addUnits),
        WorkBreadcrumbNav(
            name: WorkEnum.addGroup.label, source: WorkEnum.addGroup),
        WorkBreadcrumbNav(name: WorkEnum.work.label, source: WorkEnum.work),
      ];
      List<WorkBreadcrumbNav> organization = [];
      for (var value in joinedCompanies) {
        organization.add(
          WorkBreadcrumbNav(
              name: value.teamName,
              id: value.id,
              image: value.target.avatarThumbnail(),
              source: value),
        );
      }
      work['组织'] = organization;
    }
  }
}

class WorkBreadcrumbNav extends BaseBreadcrumbNavModel {
  WorkBreadcrumbNav(
      {super.id = '',
      super.name = '',
      super.children = const [],
      Uint8List? image,
      dynamic source}) {
    this.image = image;
    this.source = source;
  }
}

enum WorkEnum {
  addFriends("加好友"),
  addUnits("加单位"),
  addGroup("加群"),
  work("办事");

  final String label;

  const WorkEnum(this.label);
}

