import 'package:get/get.dart';
import 'package:orginone/dart/core/thing/ispecies.dart';
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

 void clearSpecies() {
   state.selectedSpecies.clear();
 }

 void removeSpecies(index) {
   state.selectedSpecies.removeRange(index + 1, state.selectedSpecies.length);
   state.selectedSpecies.refresh();
 }

  void selectSpecies(ISpeciesItem item) {
    state.selectedSpecies.add(item);
  }
}
