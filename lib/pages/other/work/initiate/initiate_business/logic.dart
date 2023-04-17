import 'package:get/get.dart';
import 'package:orginone/dart/core/thing/ispecies.dart';
import 'package:orginone/pages/other/choice_gb/state.dart';
import 'package:orginone/routers.dart';

import '../../../../../dart/core/getx/base_controller.dart';
import 'state.dart';


class InitiateBusinessController extends BaseController<InitiateBusinessState> {
 final InitiateBusinessState state = InitiateBusinessState();


 void createInstance(ISpeciesItem item) {
   Get.toNamed(Routers.workStart,arguments: {"species":item});
   // Get.toNamed(Routers.choiceGb)?.then((value){
   //   if(value!=null){
   //     Get.toNamed(Routers.workStart,arguments: {"species":value});
   //   }
   // });
 }


  void selectSpecies(ISpeciesItem item) {
     Get.toNamed(Routers.choiceGb,arguments: {"head":"全部业务",'gb':item,"showPopupMenu":false,'function':GbFunction.work});
  }

  void workStart(ISpeciesItem item) {
    Get.toNamed(Routers.workStart,arguments: {"species":item});
  }
}
