import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/chat/session.dart';
import 'package:orginone/pages/chat/widgets/chat_item.dart';
import 'package:orginone/components/widgets/gy_scaffold.dart';

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
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: chats.length,
        itemBuilder: (BuildContext context, int index) {
          var chat = chats[index];
          return MessageItemWidget(
            chat: chat,
            enabledSlidable: false,
          );
        },
      ),
    );
  }
}

class MessageChatsListController extends GetxController {
  late List<ISession> chats;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    chats = Get.arguments['chats'];
    chats.sort((f, s) {
      return (s.chatdata.lastMsgTime) - (f.chatdata.lastMsgTime);
    });
  }
}

class MessageChatsListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MessageChatsListController());
  }
}
