import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_controller.dart';
import 'package:orginone/event/tap_navigator.dart';
import 'package:orginone/pages/universal_navigator/state.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/common_tree_management.dart';

import '../../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class WarehouseManagementController
    extends BaseBreadcrumbNavController<WarehouseManagementState> {
  final WarehouseManagementState state = WarehouseManagementState();


  void jumpUniversalNavigator(String name) {
    List<NavigatorModel> data = [];
    for (var element in CommonTreeManagement().species!.children) {
      if (element.name == "财物") {
        for (var element in element.children) {
          data.add(NavigatorModel.formSpecies(element));
        }
      }
    }
    Get.toNamed(Routers.universalNavigator,
        arguments: {"title": name, 'data': data});
  }
}

List<String> personalWork = [
  "应用",
  "文件",
  "数据",
];
