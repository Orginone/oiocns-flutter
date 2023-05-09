

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/pages/work/process_details/logic.dart';
import 'package:orginone/pages/work/state.dart';


class ProcessInfoState extends BaseGetState{

  TextEditingController comment = TextEditingController();

  ProcessDetailsController processDetailsController = Get.find<ProcessDetailsController>();

  XFlowTaskHistory get task => processDetailsController.state.todo.target;

  XFlowInstance? get flowInstance => processDetailsController.state.flowInstance.value;

  Map<String,Map<XOperationItem,dynamic>> get xAttribute => processDetailsController.state.xAttribute;
}
