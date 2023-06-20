

import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_list_state.dart';
import 'package:orginone/dart/core/thing/form.dart';
import 'package:orginone/model/thing_model.dart';

class ThingState extends BaseGetListState<ThingModel>{

  late Form form;

  late String belongId;

  ThingState(){
    form = Get.arguments['form'];
    belongId = Get.arguments['belongId'];
  }
}