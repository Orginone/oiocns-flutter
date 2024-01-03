import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_controller.dart';

import 'state.dart';

class Demo3Controller extends BaseBreadcrumbNavController<Demo3State> {
 final Demo3State state = Demo3State();

 @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    print(state.bcNav);
  }

}
