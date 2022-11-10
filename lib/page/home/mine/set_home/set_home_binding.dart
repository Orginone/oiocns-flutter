import 'package:get/get.dart';

import 'set_home_controller.dart';

class SetHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SetHomeController());
  }
}
