

import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart' hide ThingModel;
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/thing/base/work.dart';
import 'package:orginone/model/thing_model.dart';

class CreateWorkState extends BaseGetState{
  late IWorkDefine define;

  late WorkNodeModel node;

  var show = false.obs;

  var selectedThings = <ThingModel>[].obs;

  CreateWorkState(){
    define = Get.arguments['define'];
    node = Get.arguments['node'];
  }
}