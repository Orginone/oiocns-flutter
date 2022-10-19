import 'package:get/get.dart';

import 'space_choose_controller.dart';

class SpaceChooseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SpaceChooseController());
  }
}
