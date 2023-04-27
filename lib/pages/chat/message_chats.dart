import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/pages/chat/widgets/chat_item.dart';

class MessageChats extends GetView<SettingController> {
  const MessageChats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var chats = controller.provider.user?.allChats();
      if (chats == null) {
        return const SizedBox();
      }
      return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: chats.length,
        itemBuilder: (BuildContext context, int index) {
          var chat = chats[index];
          return MessageItemWidget(chat: chat);
        },
      );
    });
  }
}