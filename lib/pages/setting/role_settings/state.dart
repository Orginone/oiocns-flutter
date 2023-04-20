import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/target/authority/iidentity.dart';
import 'package:orginone/dart/core/target/itarget.dart';

class RoleSettingsState extends BaseGetState {
  late TabController tabController;
  late ITarget target;

  var identitys = <IIdentity>[].obs;

  RoleSettingsState(){
    target = Get.arguments?['target'];
  }
}
