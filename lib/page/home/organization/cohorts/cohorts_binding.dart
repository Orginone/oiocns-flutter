import 'package:get/get.dart';

import 'cohorts_controller.dart';

class CohortsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CohortsController());
  }
}
