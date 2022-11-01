import 'package:get/get.dart';

import 'instance_controller.dart';

class InstanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => InstanceController());
  }
}
