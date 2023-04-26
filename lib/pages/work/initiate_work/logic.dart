import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_controller.dart';
import 'package:orginone/pages/work/network.dart';
import 'package:orginone/routers.dart';

import 'state.dart';

class InitiateWorkController extends BaseBreadcrumbNavController<InitiateWorkState> {
  final InitiateWorkState state = InitiateWorkState();

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
    if (state.model.value!.workEnum != null) {
      switch (state.model.value!.workEnum) {
        case WorkEnum.outAgency:
          await WorkNetWork.initGroup(state.model.value!);
          break;
        case WorkEnum.workCohort:
          await WorkNetWork.initCohorts(state.model.value!);
          break;
      }
    }
    if(state.model.value?.name == "发起办事"){
      await WorkNetWork.initSpecies(state.model.value!.children[0]);
    }else if(state.model.value?.workType == WorkType.organization){
      await WorkNetWork.initSpecies(state.model.value!);
    }

    state.model.refresh();
  }

  void jumpNext(WorkBreadcrumbNav work) {
    if(work.children.isEmpty){
      if(work.workType == WorkType.group){
        jumpWorkList(work);
      }else{
        Get.toNamed(Routers.initiateWork,
            preventDuplicates: false, arguments: {"data": work});
      }
    }else{
      Get.toNamed(Routers.initiateWork,
          preventDuplicates: false, arguments: {"data": work});
    }
  }

  void createWork(WorkBreadcrumbNav work) {
    Get.toNamed(Routers.workStart,arguments: {"data":work});
  }

  void jumpWorkList(WorkBreadcrumbNav work) {
    Get.toNamed(Routers.workList,arguments: {"data": work});
  }

}
