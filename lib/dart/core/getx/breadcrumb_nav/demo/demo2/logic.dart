import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_controller.dart';

import 'state.dart';

class Demo2Controller extends BaseBreadcrumbNavController<Demo2State> {
 final Demo2State state = Demo2State();

 @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    print(state.bcNav);
  }

}
