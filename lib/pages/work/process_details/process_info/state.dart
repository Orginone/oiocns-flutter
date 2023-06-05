

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

  XForm? get workForm => processDetailsController.state.workForm.value;

  List<XForm> get thingForm => processDetailsController.state.thingForm;

  TabController? get subTabController => processDetailsController.state.subTabController;
}
