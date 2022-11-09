import 'package:get/get.dart';
import 'package:orginone/util/hub_util.dart';

import 'chat_controller.dart';
import 'component/chat_box.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChatController());
    Get.lazyPut(() {
      var chatController = Get.find<ChatController>();
      return ChatBoxController(
        imageCallback: chatController.imagePicked,
        voiceCallback: chatController.sendVoice,
        fileCallback: chatController.filePicked,
      );
    });
  }
}
