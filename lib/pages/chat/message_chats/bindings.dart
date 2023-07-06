

import 'package:orginone/dart/core/getx/base_bindings.dart';
import 'package:orginone/pages/chat/message_chats/message_chats_controller.dart';

class MessageChatsControllerBinding extends BaseBindings<MessageChatsController> {
  @override
  MessageChatsController getController() {
   return MessageChatsController();
  }

}