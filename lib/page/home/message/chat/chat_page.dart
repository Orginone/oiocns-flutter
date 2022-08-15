import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:orginone/page/home/message/chat/component/chat_box.dart';
import 'package:orginone/page/home/message/chat/chat_controller.dart';

class ChatPage extends GetView<ChatController> {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        leading: GFIconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
          type: GFButtonType.transparent,
        ),
        title: Obx(() => Text(controller.title.value)),
        actions: <Widget>[
          GFIconButton(icon: const Icon(Icons.favorite), onPressed: () {})
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Scrollbar(
                  key: UniqueKey(),
                  child: Obx(() => ListView.builder(
                      controller: controller.messageScrollController,
                      scrollDirection: Axis.vertical,
                      itemCount: controller.messageItems.length,
                      itemBuilder: (BuildContext context, int index) {
                        return controller.messageItems[index];
                      })))),
          const ChatBox()
        ],
      ),
    );
  }
}
