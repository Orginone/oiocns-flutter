import 'package:flutter/material.dart' hide Form;
import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/thing/standard/form.dart';

class ThingDetailsState extends BaseGetState {
  late TabController tabController;
  late AnyThingModel thing;
  late Form form;

  ThingDetailsState() {
    thing = Get.arguments['thing'];
    form = Get.arguments['form'];
  }
}

const List<String> tabTitle = [
  '基本信息',
  '归档痕迹',
];
