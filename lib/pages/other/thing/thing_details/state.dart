

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/model/thing_model.dart';

class ThingDetailsState extends BaseGetState{
  late TabController tabController;
  late ThingModel thing;


  ThingDetailsState(){
    thing = Get.arguments['thing'];
  }
}

const List<String> tabTitle = [
  '基本信息',
  '历史痕迹',
];