import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/chat/message/msgchat.dart';
import 'package:orginone/pages/chat/widgets/chat_item.dart';
import 'package:orginone/widget/gy_scaffold.dart';

class MessageChats extends GetView<SettingController> {
  const MessageChats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var chats = controller.chat.chats;
      if (chats.isEmpty) {
        return Container();
      }
      chats.sort((f, s) {
        return (s.chatdata.value.lastMsgTime) - (f.chatdata.value.lastMsgTime);
      });
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

class MessageChatsList extends GetView<MessageChatsListController> {
  const MessageChatsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var chats = controller.chats;
    if (controller.chats.isEmpty) {
      return Container();
    }
    return GyScaffold(
      titleName: "全部回话",
      body: Container(
        color: Colors.white,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: chats.length,
          itemBuilder: (BuildContext context, int index) {
            var chat = chats[index];
            return MessageItemWidget(chat: chat);
          },
        ),
      ),
    );
  }
}

class MessageChatsListController extends GetxController {
  late List<IMsgChat> chats;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    chats = Get.arguments['chats'];
    chats.sort((f, s) {
      return (s.chatdata.value.lastMsgTime) - (f.chatdata.value.lastMsgTime);
    });
  }
}

class MessageChatsListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MessageChatsListController());
  }

}

