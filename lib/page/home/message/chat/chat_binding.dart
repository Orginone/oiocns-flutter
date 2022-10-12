import 'package:get/get.dart';

import 'chat_controller.dart';
import 'component/chat_box.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChatController());
    Get.lazyPut(() {
      var chatController = Get.find<ChatController>();
      return ChatBoxController(
        sendCallback: chatController.sendOneMessage,
        imageCallback: chatController.imagePicked,
      );
    });
  }
}
