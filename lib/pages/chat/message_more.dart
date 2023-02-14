import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/components/template/originone_scaffold.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/dart/controller/chat/index.dart';

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
        child: Obx(() => ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: controller.getChatSize(),
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return group_item_widget.dart(chatGroup: controller.get(index));
          },
        )),
      ),
    );
  }
}
