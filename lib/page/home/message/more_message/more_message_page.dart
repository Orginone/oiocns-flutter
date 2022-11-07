import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/component/unified_scaffold.dart';
import 'package:orginone/page/home/message/message_controller.dart';

import '../../../../component/a_font.dart';
import '../../../../util/widget_util.dart';
import '../component/group_item_widget.dart';

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
          await controller.refreshCharts();
        },
        child: GetBuilder<MessageController>(
          builder: (controller) => ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: controller.orgChatCache.chats.length,
            itemBuilder: (BuildContext context, int index) {
              return GroupItemWidget(index);
            },
          ),
        ),
      ),
    );
  }
}
