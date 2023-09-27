import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/base_get_list_state.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/thing/standard/form.dart';

import '../../../model/thing_model.dart';

class ChoiceThingState extends BaseGetListState<AnyThingModel> {
  var selectedThings = <AnyThingModel>[].obs;

  late IForm form;

  late String belongId;

  ChoiceThingState() {
    form = Get.arguments['form'];
    belongId = Get.arguments['belongId'];
  }
}
