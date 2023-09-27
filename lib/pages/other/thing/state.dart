import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/getx/base_get_list_state.dart';
import 'package:orginone/dart/core/thing/standard/form.dart';
import 'package:orginone/model/thing_model.dart';

class ThingState extends BaseGetListState<AnyThingModel> {
  late Form form;

  late String belongId;

  String? filter;
  ThingState() {
    form = Get.arguments['form'];
    belongId = Get.arguments['belongId'];
    filter = Get.arguments['filter'];
  }
}
