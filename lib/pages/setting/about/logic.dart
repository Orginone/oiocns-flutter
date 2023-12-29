import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:orginone/pages/setting/about/state.dart';

class AboutController extends BaseController<AboutState> {
  void backToHome() {
    Get.back();
  }
}
