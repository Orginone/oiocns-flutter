

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/thing/base/flow.dart';

class CreateWorkState extends BaseGetState{
  late IWorkDefine define;

  Rxn<XForm> workForm = Rxn();

  var thingForm = <XForm>[].obs;

  late TabController tabController;
  CreateWorkState(){
    define = Get.arguments['define'];
  }
}

enum SubTableEnum{
  allChange("批量修改"),
  addTable("新增"),
  choiceTable("选择");

  final String lable;
  const SubTableEnum(this.lable);
}