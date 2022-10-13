import 'package:get/get.dart';
import 'package:orginone/page/home/message/message_controller.dart';
import '../../component/loading_button.dart';
import '../home/message/chat/chat_controller.dart';

import 'login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
    Get.lazyPut(() => LoadingButtonController());
  }
}
