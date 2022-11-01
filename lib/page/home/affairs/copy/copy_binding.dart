import 'package:get/get.dart';

import 'copy_controller.dart';

class CopyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CopyController());
  }
}
