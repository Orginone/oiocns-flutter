

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/pages/other/work/process_details/logic.dart';

import '../../to_do/state.dart';

class ProcessInfoState extends BaseGetState{

  TextEditingController comment = TextEditingController();

  ProcessDetailsController processDetailsController = Get.find<ProcessDetailsController>();

  WorkEnum? get type =>processDetailsController.state.type;

  XFlowTask get task => processDetailsController.state.task;

  XFlowInstance? get flowInstance => processDetailsController.state.flowInstance.value;

  Map<String,Map<XAttribute,dynamic>> get xAttribute => processDetailsController.state.xAttribute;
}
