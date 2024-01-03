import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/chat/message.dart';
import 'package:orginone/utils/date_util.dart';
import 'package:orginone/components/widgets/gy_scaffold.dart';
import 'package:orginone/config/unified.dart';
import 'index.dart';
import 'widgets/messgae_receive_item.dart';

class MessageReceivePage extends GetView<MessageReceiveController> {
  const MessageReceivePage({Key? key}) : super(key: key);
  Widget buildList(List<XTarget> targets, [List<IMessageLabel>? labels]) {
    return ListView.builder(
      itemBuilder: (context, index) {
        var target = targets[index];
        String hint = target.remark ?? "";
        if (labels != null) {
          IMessageLabel label =
              labels.firstWhere((element) => element.userId == target.id);
          hint = "已读:${CustomDateUtil.getSessionTime(label.time)}";
        }
        return MessageReceiveItem(target: target, hint: hint);
      },
      itemCount: targets.length,
    );
  }

  // 主视图
  Widget _buildView() {
    return Column(
      children: [
        TabBar(
          tabs: [
            Tab(
              text: "${controller.tabs[0]}(${controller.readMember.length})",
            ),
            Tab(
              text: "${controller.tabs[1]}(${controller.unreadMember.length})",
            )
          ],
          controller: controller.tabController,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorColor: XColors.black,
          unselectedLabelColor: Colors.grey,
          unselectedLabelStyle: TextStyle(fontSize: 21.sp),
          labelColor: XColors.black,
          labelStyle: TextStyle(fontSize: 23.sp),
        ),
        Container(
          height: 10.h,
          width: double.infinity,
          color: Colors.grey.shade100,
        ),
        Expanded(
          child: TabBarView(
            controller: controller.tabController,
            children: [
              buildList(controller.readMember, controller.labels),
              buildList(controller.unreadMember),
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MessageReceiveController>(
      init: MessageReceiveController(),
      id: "message_receive_page",
      builder: (_) {
        return GyScaffold(
          titleName: "消息接收人列表",
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.close,
                color: Colors.black,
              )),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
