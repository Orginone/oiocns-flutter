

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/target/base/belong.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/thing/base/flow.dart';

class CreateWorkState extends BaseGetState{
  late IWorkDefine define;

  Rxn<XForm> workForm = Rxn();

  var thingForm = <XForm>[].obs;

  late TabController tabController;

  late ITarget target;
  CreateWorkState(){
    define = Get.arguments['define'];
    target = Get.arguments['target'];
  }
}

enum SubTableEnum{
  allChange("批量修改"),
  addTable("新增"),
  choiceTable("选择");

  final String label;
  const SubTableEnum(this.label);
}