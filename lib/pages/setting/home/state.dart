import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';

class SettingCenterState extends BaseGetState {
  late TabController tabController;

  SettingController get setting => Get.find<SettingController>();

  var selectedGroup = <String>[].obs;

  var groupData = Rxn();
}

const List<String> tabTitle = [
  '关系',
  '标准',
];

enum CompanySpaceEnum {
  company('单位'),
  innerAgency("内部机构"),
  outAgency("外部机构"),
  stationSetting("岗位设置"),
  companyCohort("单位群组");

  final  String label;

  const CompanySpaceEnum(this.label);

  static CompanySpaceEnum findEnum(String label){
    switch(label){
      case "内部机构":
        return CompanySpaceEnum.innerAgency;
      case "外部机构":
        return CompanySpaceEnum.outAgency;
      case "岗位设置":
        return CompanySpaceEnum.stationSetting;
      case "单位群组":
        return CompanySpaceEnum.companyCohort;
      default:
        return CompanySpaceEnum.company;
    }
  }
}
const companySpace = [
  '内部机构',
  '外部机构',
  '岗位设置',
  '单位群组',
];


const userSpace = [
  '个人信息',
  '个人群组',
];
