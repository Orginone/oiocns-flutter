import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/widget/template/originone_scaffold.dart';
import 'package:orginone/widget/unified.dart';
import 'package:orginone/dart/controller/chat/chat_controller.dart';
import 'package:orginone/pages/chat/widgets/group_item_widget.dart';

class MoreMessagePage extends GetView<ChatController> {
  const MoreMessagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OrginoneScaffold(
      appBarTitle: Text("更多会话", style: XFonts.size22Black3),
      appBarCenterTitle: true,
      appBarLeading: XWidgets.defaultBackBtn,
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.chatRefresh();
        },
        child: Obx(() {
          return ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: controller.groups.length,
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return GroupItemWidget(chatGroup: controller.groups[index]);
            },
          );
        }),
      ),
    );
  }
}
