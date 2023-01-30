import 'package:get/get.dart';
import '../../components/loading_button.dart';

import 'login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
    Get.lazyPut(() => LoadingButtonController());
  }
}
