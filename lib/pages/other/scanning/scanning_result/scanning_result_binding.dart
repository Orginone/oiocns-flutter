import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:orginone/pages/other/scanning/scanning_result/scanning_result_controller.dart';

class ScanningResultBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ScanningResultController());
  }
}
