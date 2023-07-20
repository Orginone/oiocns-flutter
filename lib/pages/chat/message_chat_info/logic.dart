import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/routers.dart';

import 'state.dart';

class MessageChatInfoController extends BaseController<MessageChatInfoState> {
 final MessageChatInfoState state = MessageChatInfoState();

  void jumpQr() {
   Get.toNamed(
    Routers.shareQrCode,
    arguments: {"entity": (state.chat as ITarget).metadata},
   );
  }

  void jumpMessage() {
   state.chat.onMessage();
   Get.offAndToNamed(Routers.messageChat, arguments: state.chat);
  }
}
