import 'package:get/get.dart';
import 'package:orginone/pages/universal_navigator/state.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/common_tree_management.dart';

import '../../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class InitiateWorkController extends BaseController<InitiateWorkState> {
  final InitiateWorkState state = InitiateWorkState();

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
