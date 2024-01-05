import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:orginone/pages/relation/about/state.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutController extends BaseController<AboutState> {
  RxString version = ''.obs;

  @override
  void onReady() {
    super.onReady();
    PackageInfo.fromPlatform().then((value) {
      version.value = 'Version ${value.version}';
    });
  }

  void backToHome() {
    Get.back();
  }
}
