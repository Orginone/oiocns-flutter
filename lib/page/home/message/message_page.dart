import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:orginone/page/home/message/message_controller.dart';

import 'component/group_item_widget.dart';

class MessagePage extends GetView<MessageController> {
  const MessagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        width: 120.w,
        child: TabBar(
          controller: controller.tabController,
          indicatorSize: TabBarIndicatorSize.label,
          labelPadding: EdgeInsets.only(top: 10.h, bottom: 6.h),
          labelStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          labelColor: Colors.black,
          tabs: const [
            Text("会话"),
            Text("通讯录"),
          ],
        ),
      ),
      Expanded(
        child: TabBarView(
          controller: controller.tabController,
          children: [_chat(), _relation()],
        ),
      )
    ]);
  }

  Widget _chat() {
    return RefreshIndicator(
      onRefresh: () async {
        await controller.refreshCharts();
      },
      child: GetBuilder<MessageController>(
        init: controller,
        builder: (controller) => ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: controller.orgChatCache.chats.length,
          itemBuilder: (BuildContext context, int index) {
            return GroupItemWidget(index);
          },
        ),
      ),
    );
  }

  Widget _relation() {
    return Container();
  }
}
