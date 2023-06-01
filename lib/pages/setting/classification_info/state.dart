

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/thing/base/flow.dart';
import 'package:orginone/dart/core/thing/base/form.dart';
import 'package:orginone/dart/core/thing/base/species.dart';
import 'package:orginone/pages/setting/home/state.dart';

class ClassificationInfoState extends BaseGetState{
  late dynamic species;
  late TabController tabController;
  late List<ClassificationEnum> tabTitle;
  late SettingNavModel data;

  var currentIndex = 0.obs;

  List<XProperty> propertys = [];

  ClassificationInfoState() {
    data = Get.arguments['data'];
    species = data.source;
    tabTitle = [ClassificationEnum.info];
    if(species is IForm){
      tabTitle.addAll([ClassificationEnum.attrs]);
    }
    if(species is FlowDefine){
      tabTitle.addAll([ClassificationEnum.attrs]);
    }
    if(species is ISpeciesItem){
      switch (SpeciesType.getType(species.metadata.typeName)) {
        case SpeciesType.store:
          tabTitle.add(ClassificationEnum.form);
          break;
        case SpeciesType.application:
          tabTitle.addAll([ClassificationEnum.attrs]);
          break;
        case SpeciesType.market:
        case SpeciesType.work:
          tabTitle.add(ClassificationEnum.work);
          break;
      }
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