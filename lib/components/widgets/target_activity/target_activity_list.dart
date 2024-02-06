import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:orginone/components/widgets/target_activity/target_activity_view.dart';
import 'package:orginone/dart/core/chat/activity.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'activity_message.dart';

//特定Target动态列表
class TargetActivityList extends StatelessWidget {
  const TargetActivityList({super.key});

  TargetActivityViewController get controller => Get.find();
  Rx<IActivity> get activity => controller.state.activity.obs;
  Rx<IActivityMessage?> get activityMessage =>
      controller.state.activityMessage.obs;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollStartNotification) {
          // 开始滚动
        } else if (notification is ScrollUpdateNotification) {
          // 正在滚动。。。总滚动距离：${notification.metrics.maxScrollExtent}"
        } else if (notification is ScrollEndNotification) {
          activity.value.load();
          // "停止滚动"
        }
        return true;
      },
      child: RefreshIndicator(
        onRefresh: () => controller.state.refresh(),
        child: Obx(() {
          return ScrollablePositionedList.builder(
            // padding: EdgeInsets.only(left: 10.w, right: 10.w),
            // shrinkWrap: true,
            key: controller.state.scrollKey,
            // reverse: true,
            physics: const ClampingScrollPhysics(),
            itemScrollController: controller.state.itemScrollController,
            // addAutomaticKeepAlives: true,
            // addRepaintBoundaries: true,
            itemCount: controller.state.activityCount.value,
            itemBuilder: (BuildContext context, int index) {
              return _item(index);
            },
          );
        }),
      ),
    );
  }

  Widget _item(int index) {
    if (activityMessage != null) {
      return ActivityMessageWidget(
        item: activityMessage.value!,
        activity: activityMessage.value!.activity,
      );
    } else {
      return ActivityMessageWidget(
        item: activity.value.activityList[index],
        activity: activity.value.activityList[index].activity,
      );
    }

    return Container();
  }
}
