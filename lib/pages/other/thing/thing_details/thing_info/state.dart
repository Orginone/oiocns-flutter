

import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/thing/base/form.dart';
import 'package:orginone/dart/core/thing/base/species.dart';
import 'package:orginone/model/thing_model.dart';
import 'package:orginone/pages/other/thing/logic.dart';
import 'package:orginone/pages/other/thing/thing_details/logic.dart';

class ThingInfoState extends BaseGetState{
  var attr = <XAttribute>[].obs;


  var detailsController = Get.find<ThingDetailsController>();

  ThingModel get thing => detailsController.state.thing;

  Form get form => detailsController.state.form;
}
