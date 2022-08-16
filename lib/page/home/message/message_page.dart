import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/model/message_item.dart';
import 'package:orginone/page/home/message/message_controller.dart';

import '../../../config/constant.dart';
import 'component/message_item_widget.dart';

class MessagePage extends GetView<MessageController> {
  const MessagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => RefreshIndicator(
        onRefresh: () async {
          await controller.getCharts();
          await controller.initChats();
        },
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: controller.messageItems.length,
            itemBuilder: (BuildContext context, int index) {
              MessageItem messageItem = controller.messageItemMap[index]!;
              return MessageItemWidget(messageItem.id!,
                  messageItem.name ?? Constant.emptyString, Constant.testUrl);
            })));
  }
}
