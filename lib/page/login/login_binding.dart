import 'package:get/get.dart';
import '../../component/loading_button.dart';

import 'login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
    Get.lazyPut(() => LoadingButtonController());
  }
}
