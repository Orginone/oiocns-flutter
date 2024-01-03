import 'package:get/get.dart';

import 'controller.dart';

class DynamicBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DynamicController>(() => DynamicController());
  }
}
