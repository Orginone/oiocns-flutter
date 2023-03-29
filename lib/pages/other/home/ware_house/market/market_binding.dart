import 'package:get/get.dart';
import './market_controller.dart';

class MarketBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MarketController>(() => MarketController());
  }
}
