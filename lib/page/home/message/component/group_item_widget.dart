import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/page/home/message/component/message_item_widget.dart';

import '../../../../model/db_model.dart';
import '../../../../model/user_space_relation_util.dart';
import '../message_controller.dart';

class GroupItemWidget extends GetView<MessageController> {
  final UserSpaceRelation messageGroup;
  final Rx<bool> isExpand;
  final Rx<double> height;

  GroupItemWidget(this.messageGroup, {Key? key})
      : isExpand = (messageGroup.isExpand ?? false).obs,
        height = 0.0.obs,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalKey globalKey = GlobalKey();

    return Column(
      children: [
        GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              var isExpandValue = !isExpand.value;
              UserSpaceRelationUtil.updateExpand(messageGroup.targetId!, isExpandValue);
              isExpand.value = isExpandValue;
            },
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      padding: const EdgeInsets.fromLTRB(10, 8, 0, 8),
                      child: Text(messageGroup.name ?? "",
                          style: const TextStyle(fontSize: 18))),
                  Container(
                      padding: const EdgeInsets.fromLTRB(0, 8, 10, 8),
                      child: Obx(() => isExpand.value
                          ? const Icon(
                              Icons.arrow_right,
                              size: 20,
                            )
                          : const Icon(
                              Icons.arrow_drop_down,
                              size: 20,
                            )))
                ])),
        const Divider(
          height: 0,
        ),
        AnimatedSize(
            duration: const Duration(seconds: 1),
            child: SizedBox(
                // height: height.value,
                key: globalKey,
                child: Obx(() => ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller
                            .messageGroupItemsMap[messageGroup.targetId]?.length ??
                        0,
                    itemBuilder: (context, index) {
                      var messageItem = controller
                          .messageGroupItemsMap[messageGroup.targetId]![index];
                      return MessageItemWidget(
                          messageItem.activeTargetId!,
                          messageItem.passiveTargetId!,
                          messageItem.name!,
                          messageItem.label!);
                    }))))
      ],
    );
  }
}
