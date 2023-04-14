import 'package:get/get.dart';

class CardbagController extends GetxController {
  CardbagController();

  _initData() {
    update(["cardbag"]);
  }

  void onTap() {}

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
