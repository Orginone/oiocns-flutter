import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';

import 'forget_controller.dart';

class ForgetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ForgetController());
  }
}
