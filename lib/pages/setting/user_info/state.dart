import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/target/person.dart';
import 'package:orginone/dart/core/target/team/company.dart';
import 'package:orginone/main.dart';

class UserInfoState extends BaseGetState {


  IPerson? get user => settingCtrl.user;

  var unitMember = <XTarget>[].obs;

  var joinCompany = <ICompany>[].obs;

  late TabController tabController;

  var index = 0.obs;
}


List<String> tabTitle = [
  "我的好友",
  "加入的单位",
];


