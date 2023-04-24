

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/thing/species.dart';

class ClassificationInfoState extends BaseGetState{
  late SpeciesItem species;
  late TabController tabController;
  late List<ClassificationEnum> tabTitle;

  var currentIndex = 0.obs;
  ClassificationInfoState(){
    species = Get.arguments['species'];
  }
}

enum ClassificationEnum{
  info("基本信息"),
  attrs("分类特性"),
  form("表单设计"),
  work("办事定义");

  final String label;
  const ClassificationEnum(this.label);

}