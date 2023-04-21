import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_controller.dart';
import 'package:orginone/dart/core/target/itarget.dart';
import 'package:orginone/dart/core/thing/species.dart';
import 'package:orginone/event/tap_navigator.dart';
import 'package:orginone/pages/universal_navigator/state.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/common_tree_management.dart';

import '../../../../dart/core/getx/base_controller.dart';
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

  void jumpUniversalNavigator(String name) {
    List<NavigatorModel> data = [];
    for (var element in CommonTreeManagement().species!.children) {
      if (element.name == "事项") {
        for (var element in element.children) {
          data.add(NavigatorModel.formSpecies(element));
        }
      }
    }
    Get.toNamed(Routers.universalNavigator,
        arguments: {"title": name, 'data': data});
  }
}
