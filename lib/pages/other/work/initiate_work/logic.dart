import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_controller.dart';
import 'package:orginone/dart/core/target/itarget.dart';
import 'package:orginone/routers.dart';
import 'state.dart';

class InitiateWorkController extends BaseBreadcrumbNavController<InitiateWorkState> {
  final InitiateWorkState state = InitiateWorkState();

  void jumpNext(WorkBreadcrumbNav work){
    if(work.source is ISpace){
     Get.toNamed(Routers.initiateWork,preventDuplicates: false,arguments: {"data":work});
    }else{
      switch(work.source as WorkEnum){
        case WorkEnum.addFriends:
          // TODO: Handle this case.
          break;
        case WorkEnum.addUnits:
          // TODO: Handle this case.
          break;
        case WorkEnum.addGroup:
          // TODO: Handle this case.
          break;
        case WorkEnum.work:
          // TODO: Handle this case.
          break;
      }
    }
  }

}
