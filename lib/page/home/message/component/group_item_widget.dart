import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/model/message_group_util.dart';
import 'package:orginone/page/home/message/component/message_item_widget.dart';

import '../../../../model/db_model.dart';
import '../message_controller.dart';

class GroupItemWidget extends GetView<MessageController> {
  final MessageGroup messageGroup;
  final Rx<bool> isExpand;
  final Rx<double> height;

  GroupItemWidget(this.messageGroup, {Key? key})
      : isExpand = (messageGroup.isExpand ?? false).obs,
        height = 0.0.obs,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalKey globalKey = GlobalKey();

    return Obx(() => Column(children: [
          GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                var isExpandValue = !isExpand.value;
                MessageGroupUtil.updateExpand(messageGroup.id!, isExpandValue);
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
                  child: Column(
                      children:
                          (controller.messageGroupItemsMap[messageGroup.id] ??
                                  [])
                              .map((messageItem) => MessageItemWidget(
                                  messageItem.msgGroupId,
                                  messageItem.id!,
                                  messageItem.name))
                              .toList())))
        ]));
  }
}
