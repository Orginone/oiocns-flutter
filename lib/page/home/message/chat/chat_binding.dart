import 'package:get/get.dart';

import 'chat_controller.dart';
import 'component/chat_box.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChatController());
    Get.lazyPut(() => ChatBoxController());
  }
}
