import 'package:get/get.dart';
import 'mine_info_controller.dart';

class MineInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MineInfoController());
  }
}
