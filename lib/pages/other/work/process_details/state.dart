


import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/pages/other/work/to_do/state.dart';

class ProcessDetailsState extends BaseGetState{

  TextEditingController comment = TextEditingController();

  var hideProcess = true.obs;

  late XFlowTask task;

  var flowInstance = Rxn<XFlowInstance>();

  var xAttribute = <String,Map<XAttribute,dynamic>>{}.obs;

  WorkEnum? type;

  ProcessDetailsState(){
    task = Get.arguments?['task'];
    type = Get.arguments?['type'];
  }
}