import 'package:get/get.dart';
import 'package:orginone/page/home/organization/units/units_controller.dart';

class UnitsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UnitsController());
  }
}
