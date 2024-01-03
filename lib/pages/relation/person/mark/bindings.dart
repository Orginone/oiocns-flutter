import 'package:get/get.dart';

import 'controller.dart';

class MarkBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MarkController>(() => MarkController());
  }
}
