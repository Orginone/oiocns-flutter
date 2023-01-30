import 'package:get/get.dart';
import 'package:orginone/page/home/affairs/detail/affairs_detail_controller.dart';

class AffairsDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AffairsDetailController());
  }
}
