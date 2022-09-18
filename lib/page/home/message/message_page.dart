import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/page/home/message/message_controller.dart';

import 'component/group_item_widget.dart';

class MessagePage extends GetView<MessageController> {
  const MessagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MessageController>(
        init: controller,
        builder: (controller) => ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: controller.spaces.length,
            itemBuilder: (BuildContext context, int index) {
              return GroupItemWidget(index);
            }));
  }
}
