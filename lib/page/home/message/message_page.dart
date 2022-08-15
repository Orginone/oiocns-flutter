import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/model/model.dart';
import 'package:orginone/page/home/message/message_controller.dart';

import '../../../config/constant.dart';
import 'component/group_item.dart';

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
            itemCount: controller.groupItems.length,
            itemBuilder: (BuildContext context, int index) {
              MessageGroup groupItem = controller.groupItems[index];
              return Group(groupItem.id!,
                  groupItem.name ?? Constant.emptyString, Constant.testUrl);
            })));
  }
}
