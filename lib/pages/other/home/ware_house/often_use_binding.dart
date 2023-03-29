import 'package:get/get.dart';
import './often_use_controller.dart';

class OftenUseBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OftenUseController>(() => OftenUseController());
  }
}
