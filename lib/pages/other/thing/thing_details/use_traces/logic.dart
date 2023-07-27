import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/pages/other/thing/thing_details/logic.dart';

import '../../../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class UseTracesController extends BaseController<UseTracesState> {
 final UseTracesState state = UseTracesState();

 var detailsController = Get.find<ThingDetailsController>();

 AnyThingModel get thing => detailsController.state.thing;

 @override
  void onReady() async{
    // TODO: implement onReady
    super.onReady();
    state.archives.value = thing.archives.values.toList();
  }

}
