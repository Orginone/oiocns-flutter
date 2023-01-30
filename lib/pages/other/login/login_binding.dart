import 'package:get/get.dart';
import 'package:orginone/components/loading_button.dart';
import 'login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
    Get.lazyPut(() => LoadingButtonController());
  }
}
