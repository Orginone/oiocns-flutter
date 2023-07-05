

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/work/task.dart';
import 'package:orginone/pages/work/process_details/logic.dart';
import 'package:orginone/pages/work/state.dart';


class ProcessInfoState extends BaseGetState{

  TextEditingController comment = TextEditingController();

  ProcessDetailsController processDetailsController = Get.find<ProcessDetailsController>();

  IWorkTask get todo => processDetailsController.state.todo;

  WorkNodeModel? get node => processDetailsController.state.node;

  XForm? get mainForm => processDetailsController.state.mainForm.value;

  List<XForm> get subForm => processDetailsController.state.subForm;

  TabController? get subTabController => processDetailsController.state.subTabController;
}
