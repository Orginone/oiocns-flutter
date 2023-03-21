


import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';

class ProcessDetailsState extends BaseGetState{
  var hideProcess = true.obs;

  late XFlowTask task;

  var flowInstacne = Rxn<XFlowInstance>();

  var xAttribute = <String,Map<XAttribute,dynamic>>{}.obs;

  ProcessDetailsState(){
    task = Get.arguments['task'];
  }
}