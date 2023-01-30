import 'package:get/get.dart';

import 'center_controller.dart';

class CenterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CenterController());
  }
}
