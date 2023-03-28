

import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/model/thing_model.dart';

class ThingState extends BaseGetState{

  late String title;

  late String id;

  var things = <ThingModel>[].obs;

  ThingState(){
    title = Get.arguments['title'];
    id = Get.arguments['id'];
  }
}