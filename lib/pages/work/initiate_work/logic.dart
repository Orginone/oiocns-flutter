import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_controller.dart';
import 'package:orginone/routers.dart';

import 'state.dart';

class InitiateWorkController
    extends BaseBreadcrumbNavController<InitiateWorkState> {
  final InitiateWorkState state = InitiateWorkState();

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
  }

  void jumpNext(WorkBreadcrumbNav work) {
    if (work.children.isEmpty) {
      jumpWorkList(work);
    } else {
      Get.toNamed(Routers.initiateWork,
          preventDuplicates: false, arguments: {"data": work});
    }
  }


  void jumpWorkList(WorkBreadcrumbNav work) {
    Get.toNamed(Routers.workList, arguments: {"data": work});
  }

}
