import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/api_resp/message_item_resp.dart';
import 'package:orginone/component/unified_text_style.dart';
import 'package:orginone/page/home/message/component/message_item_widget.dart';

import '../../../../api_resp/space_messages_resp.dart';
import '../../../../component/unified_edge_insets.dart';
import '../message_controller.dart';

class GroupItemWidget extends GetView<MessageController> {
  final int index;

  const GroupItemWidget(this.index, {Key? key}) : super(key: key);

  get _title => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () async {
          controller.spaces[index].isExpand =
              !controller.spaces[index].isExpand;
          controller.update();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: ltb10,
              child: Text(controller.spaces[index].name, style: text16),
            ),
            Container(
              padding: right10,
              child: GetBuilder<MessageController>(
                builder: (controller) {
                  var space = controller.spaces[index];
                  var iconData = space.isExpand
                      ? Icons.arrow_drop_down
                      : Icons.arrow_right;
                  return Icon(iconData, size: 20.w);
                },
              ),
            ),
          ],
        ),
      );

  get _list => SizedBox(
        child: GetBuilder<MessageController>(
          builder: (controller) {
            SpaceMessagesResp spaceMessages = controller.spaces[index];
            bool isExpand = spaceMessages.isExpand;
            List<MessageItemResp> messageItems = spaceMessages.chats;

            if (!isExpand) {
              return Container();
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: messageItems.length,
              itemBuilder: (context, index) {
                MessageItemResp messageItem = messageItems[index];
                return MessageItemWidget(
                    spaceMessages.id, messageItem.id, index);
              },
            );
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      _title,
      const Divider(height: 0),
      _list,
    ];
    if (controller.spaces[index].isExpand) {
      children.add(Container(margin: top5));
      children.add(const Divider(height: 0));
    }
    return Column(children: children);
  }
}
