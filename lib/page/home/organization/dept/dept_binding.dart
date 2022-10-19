import 'package:get/get.dart';

import 'dept_controller.dart';

class DeptBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DeptController());
  }
}
