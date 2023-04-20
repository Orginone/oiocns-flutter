import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_controller.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/breadcrumb_nav_instance.dart';

import 'state.dart';

class Demo1Controller extends BaseBreadcrumbNavController<Demo1State> {
  final Demo1State state = Demo1State();

  @override
  void pop(int index) {
    String routerName = state.bcNav[index].route;

    Get.until(
      (route) {
        var name = (route.settings.arguments as Map)['data'].name;
        return Get.currentRoute == routerName && state.bcNav[index].data?.name == name;
      },
    );
  }
}
