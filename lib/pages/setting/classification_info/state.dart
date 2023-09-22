import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/pages/setting/home/state.dart';

class ClassificationInfoState extends BaseGetState {
  late dynamic species;
  late TabController tabController;
  late List<ClassificationEnum> tabTitle;
  late SettingNavModel data;

  var currentIndex = 0.obs;

  List<XProperty> propertys = [];

  ClassificationInfoState() {
    data = Get.arguments['data'];
    species = data.source;
    tabTitle = [];
    switch (data.spaceEnum) {
      case SpaceEnum.person:
        tabTitle.add(ClassificationEnum.personInfo);
        break;
      case SpaceEnum.species:
        tabTitle.add(ClassificationEnum.info);
        tabTitle.add(ClassificationEnum.species);
        break;
      case SpaceEnum.applications:
        tabTitle.add(ClassificationEnum.info);
        tabTitle.add(ClassificationEnum.work);
        break;
      case SpaceEnum.form:
        tabTitle.add(ClassificationEnum.info);
        tabTitle.add(ClassificationEnum.attrs);
        break;
      default:
    }
  }
}

enum ClassificationEnum {
  info("基本信息"),
  personInfo("个人信息"),
  property("属性定义"),
  attrs("表单特性"),
  form("表单设计"),
  species("分类定义"),
  work("办事定义");

  final String label;

  const ClassificationEnum(this.label);
}
