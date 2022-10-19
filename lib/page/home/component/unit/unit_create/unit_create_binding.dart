import 'package:get/get.dart';
import 'unit_create_controller.dart';

class UnitCreateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UnitCreateController());
  }
}
