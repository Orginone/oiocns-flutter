import 'package:get/get.dart';

class ErrorPageController extends GetxController {
  ErrorPageController();

  _initData() {
    update(["error_page"]);
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
