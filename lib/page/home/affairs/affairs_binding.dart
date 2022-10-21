import 'package:get/get.dart';
import 'package:orginone/page/home/affairs/affairs_controller.dart';

class AffairsBinding extends Bindings{
  @override
  void dependencies() {
    // Get.lazyPut(() => AffairsController());
    Get.put(AffairsController());
  }

}