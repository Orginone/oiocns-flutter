


import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';

import '../../../model/thing_model.dart';

class ChoiceThingState extends BaseGetState {
  var things = <ThingModel>[].obs;

  var selectedThings = <ThingModel>[].obs;

  late XForm form;

  late String belongId;

  ChoiceThingState(){
    form = Get.arguments['form'];
    belongId = Get.arguments['belongId'];
  }
}