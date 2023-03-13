import 'package:get/get.dart';
import './recently_opened_controller.dart';

class RecentlyOpenedBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RecentlyOpenedController>(() => RecentlyOpenedController());
  }
}
