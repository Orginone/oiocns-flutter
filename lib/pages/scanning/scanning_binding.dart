import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:orginone/page/scanning/scanning_controller.dart';

class ScanningBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ScanningController());
  }
}
