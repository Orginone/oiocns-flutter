

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/thing/form.dart';
import 'package:orginone/dart/core/work/apply.dart';
import 'package:orginone/dart/core/work/index.dart';

class CreateWorkState extends BaseGetState{
  late IWork work;

  Rxn<IForm> mainForm = Rxn();

  var subForm = <IForm>[].obs;

  late TabController tabController;

  TextEditingController remark = TextEditingController();

  IWorkApply? apply;

  late ITarget target;
  CreateWorkState(){
    work = Get.arguments['work'];
    target = Get.arguments['target'];
  }
}

enum SubTableEnum{
  addTable("新增"),
  choiceTable("选择");

  final String label;
  const SubTableEnum(this.label);
}