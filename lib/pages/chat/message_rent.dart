import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/controller/chat/chat_controller.dart';
import 'package:orginone/pages/chat/widgets/message_item_widget.dart';

class MessageRecent extends GetView<ChatController> {
  const MessageRecent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      int chatSize = controller.getChatSize();
      return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: chatSize,
        itemBuilder: (BuildContext context, int index) {
          var chat = controller.chats[index];
          return MessageItemWidget(chat: chat, remove: controller.removeChat);
        },
      );
    });
  }
}
