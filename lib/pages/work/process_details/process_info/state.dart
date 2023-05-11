

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/pages/work/process_details/logic.dart';
import 'package:orginone/pages/work/state.dart';


class ProcessInfoState extends BaseGetState{

  TextEditingController comment = TextEditingController();

  ProcessDetailsController processDetailsController = Get.find<ProcessDetailsController>();

  XWorkTask get task => processDetailsController.state.todo;

  XWorkInstance? get flowInstance => processDetailsController.state.workInstance;

  List<XForm> get useForm => processDetailsController.state.useForm;
}
