import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/target/outTeam/group.dart';
import 'package:orginone/dart/core/target/team/company.dart';

class CompanyInfoState extends BaseGetState {
  // ICompany? get company => settingController.company;

  var unitMember = <XTarget>[].obs;

  var joinGroup = <IGroup>[].obs;

  late TabController tabController;

  var index = 0.obs;

  late ICompany company;

  CompanyInfoState() {
    company = Get.arguments['company'];
  }
}

List<String> tabTitle = [
  "单位成员",
  "加入的组织群",
];
