import 'package:get/get.dart';

import 'controller.dart';

class SecurityBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SecurityController>(() => SecurityController());
  }
}
