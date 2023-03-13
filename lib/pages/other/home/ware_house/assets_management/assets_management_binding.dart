import 'package:get/get.dart';
import './assets_management_controller.dart';

class AssetsManagementBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AssetsManagementController>(() => AssetsManagementController());
  }
}
