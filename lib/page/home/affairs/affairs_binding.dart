import 'package:get/get.dart';

import 'affairs_page_controller.dart';

class AffairsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AffairsPageController());
  }
}
