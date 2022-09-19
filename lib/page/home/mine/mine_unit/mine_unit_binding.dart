import 'package:get/get.dart';
import 'mine_unit_controller.dart';

class MineUnitBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MineUnitController());
  }
}
