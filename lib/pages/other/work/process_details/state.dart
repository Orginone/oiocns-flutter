


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/pages/other/work/to_do/state.dart';

class ProcessDetailsState extends BaseGetState{

  var hideProcess = true.obs;

  late XFlowTask task;

  var flowInstance = Rxn<XFlowInstance>();

  var xAttribute = <String,Map<XAttribute,dynamic>>{}.obs;

  WorkEnum? type;

  late TabController tabController;

  ProcessDetailsState(){
    task = Get.arguments?['task'];
    type = Get.arguments?['type'];
  }
}

const List<String> tabTitle = [
  '基本信息',
  '历史痕迹',
];