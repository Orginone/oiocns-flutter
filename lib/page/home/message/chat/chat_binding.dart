import 'package:get/get.dart';

import 'chat_controller.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChatController());
  }
}
