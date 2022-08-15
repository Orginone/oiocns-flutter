import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:orginone/page/home/message/chat/chat_controller.dart';

class ChatBox extends GetView<ChatController> {
  const ChatBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Expanded(
              flex: 8,
              child: Container(
                constraints: const BoxConstraints(maxHeight: 40, minHeight: 40),
                alignment: Alignment.centerLeft,
                child: TextField(
                    controller: controller.messageText,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        border: OutlineInputBorder(),
                        hintText: "请输入聊天信息")),
              )),
          Container(margin: const EdgeInsets.fromLTRB(10, 0, 0, 0)),
          Expanded(
              flex: 2,
              child: GFButton(
                  size: GFSize.MEDIUM,
                  onPressed: () {
                    // 发送消息
                    controller.sendOneMessage();
                  },
                  text: "发送"))
        ]));
  }
}
