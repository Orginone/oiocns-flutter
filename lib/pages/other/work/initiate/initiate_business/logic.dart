import 'package:get/get.dart';
import 'package:orginone/routers.dart';

import '../../../../../dart/core/getx/base_controller.dart';
import 'state.dart';


class InitiateBusinessController extends BaseController<InitiateBusinessState> {
 final InitiateBusinessState state = InitiateBusinessState();


 void createInstance() {
   Get.toNamed(Routers.choiceGb)?.then((value){
     if(value!=null){
       Get.toNamed(Routers.workStart,arguments: {"species":value});
     }
   });
 }
}
