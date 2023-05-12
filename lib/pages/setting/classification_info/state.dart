

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/pages/setting/home/setting/state.dart';

class ClassificationInfoState extends BaseGetState{
  late dynamic species;
  late TabController tabController;
  late List<ClassificationEnum> tabTitle;
  late SettingNavModel data;

  var currentIndex = 0.obs;

  ClassificationInfoState() {
    data = Get.arguments['data'];
    species = data.source;
    tabTitle = [ClassificationEnum.info];
    switch (SpeciesType.getType(species.metadata.typeName)) {
      case SpeciesType.store:
        tabTitle.add(ClassificationEnum.property);
        break;
      case SpeciesType.workForm:
      case SpeciesType.commodity:
        tabTitle.addAll([ClassificationEnum.attrs, ClassificationEnum.form]);
        break;
      case SpeciesType.market:
      case SpeciesType.workItem:
        tabTitle.add(ClassificationEnum.work);
        break;
    }
  }
}

enum ClassificationEnum {
  info("基本信息"),
  property("属性定义"),
  attrs("表单特性"),
  form("表单设计"),
  work("办事定义");

  final String label;

  const ClassificationEnum(this.label);
}