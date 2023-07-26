import 'package:get/get.dart';

import 'controller.dart';

class CardbagBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CardbagController>(() => CardbagController());
  }
}
