import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/components/a_font.dart';
import 'package:orginone/components/unified_scaffold.dart';
import 'package:orginone/dart/controller/message/message_controller.dart';
import 'package:orginone/pages/chat/components/group_item_widget.dart';
import 'package:orginone/util/widget_util.dart';

class MoreMessagePage extends GetView<MessageController> {
  const MoreMessagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UnifiedScaffold(
      appBarTitle: Text("更多会话", style: AFont.instance.size22Black3),
      appBarCenterTitle: true,
      appBarLeading: WidgetUtil.defaultBackBtn,
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.refreshMails();
        },
        child: Obx(() => ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: controller.getSize(),
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return GroupItemWidget(chatGroup: controller.get(index));
              },
            )),
      ),
    );
  }
}
