import 'package:get/get.dart';
import 'mine_card_controller.dart';

class MineCardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MineCardController());
  }
}
