


import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';

import '../../../model/thing_model.dart';

class ChoiceThingState extends BaseGetState {
  var things = <ThingModel>[].obs;

  var selectedThings = <ThingModel>[].obs;
}