import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/pages/chat/widgets/chat_item.dart';

class MessageChats extends HookWidget {
  const MessageChats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var ctrl = Get.find<SettingController>();
    var chats = useState(ctrl.provider.user?.chats ?? []);
    chats.value.sort((f, s) {
      return (s.chatdata.lastMsgTime) - (f.chatdata.lastMsgTime);
    });
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: chats.value.length,
      itemBuilder: (BuildContext context, int index) {
        var chat = chats.value[index];
        return MessageItemWidget(chat: chat);
      },
    );
  }
}
