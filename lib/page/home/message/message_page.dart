import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/page/home/message/message_controller.dart';

import 'component/group_item_widget.dart';

class MessagePage extends GetView<MessageController> {
  const MessagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => RefreshIndicator(
        onRefresh: () async {
          await controller.getCharts();
          await controller.initGroups();
          await controller.initChats();
        },
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: controller.messageGroups.length,
            itemBuilder: (BuildContext context, int index) {
              return GroupItemWidget(controller.messageGroups[index]);
            })));
  }
}
