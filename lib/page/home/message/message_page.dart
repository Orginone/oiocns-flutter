import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/page/home/message/message_controller.dart';

import 'component/group_item_widget.dart';

class MessagePage extends GetView<MessageController> {
  const MessagePage({Key? key}) : super(key: key);

  get _body => GetBuilder<MessageController>(
      init: controller,
      builder: (controller) => ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: controller.spaces.length,
          itemBuilder: (BuildContext context, int index) {
            return GroupItemWidget(index);
          }));

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () async {
          await controller.getCharts();
        },
        child: _body);
  }
}
