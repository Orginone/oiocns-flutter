import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/api_resp/message_target.dart';
import 'package:orginone/api_resp/org_chat_cache.dart';
import 'package:orginone/component/a_font.dart';
import 'package:orginone/logic/chat/i_chat.dart';
import 'package:orginone/page/home/message/component/message_item_widget.dart';

import '../../api_resp/space_messages_resp.dart';
import '../../controller/message/message_controller.dart';

class GroupItemWidget extends StatelessWidget {
  final IChatGroup chatGroup;

  const GroupItemWidget(this.chatGroup, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var line = const Divider(height: 0);
    List<Widget> children = [_title, line, _list];
    children.add(Obx(() => chatGroup.isOpened ? Container() : line));
    return Column(children: children);
  }

  get _title {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        chat.isExpand = !chat.isExpand;
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.only(left: 25.w, top: 10.h, bottom: 10.h),
            child: Text(
              "${chatGroup.spaceName}(${chatGroup.chats.length})",
              style: AFont.instance.size22Black3W500,
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: 25.w),
            child: GetBuilder<MessageController>(
              builder: (controller) {
                var iconData =
                    chat.isExpand ? Icons.arrow_drop_down : Icons.arrow_right;
                return Icon(iconData, size: 30.w);
              },
            ),
          ),
        ],
      ),
    );
  }

  get _list => SizedBox(
        child: GetBuilder<MessageController>(
          builder: (controller) {
            OrgChatCache orgChatCache = controller.orgChatCache;
            ChatGroup spaceMessages = orgChatCache.chats[index];
            bool isExpand = spaceMessages.isExpand;
            if (spaceMessages.id == "topping") {
              List<MessageItemWidget> tops = [];
              for (var space in orgChatCache.chats) {
                var items = space.chats;
                for (var item in items) {
                  if (item.isTop == true) {
                    tops.add(MessageItemWidget(space.id, item));
                  }
                }
              }
              tops.sort((first, second) {
                var firstItem = first.item;
                var secondItem = second.item;
                if (firstItem.msgTime == null || secondItem.msgTime == null) {
                  return 0;
                } else {
                  return -firstItem.msgTime!.compareTo(secondItem.msgTime!);
                }
              });
              if (!isExpand) {
                tops = tops.where((item) {
                  var data = item.item;
                  return data.noRead != null && data.noRead != 0;
                }).toList();
              }
              var bottom = tops.isEmpty ? 0.h : 16.h;
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: tops.length,
                padding: EdgeInsets.only(bottom: bottom),
                itemBuilder: (context, index) {
                  return tops[index];
                },
              );
            } else {
              List<MessageTarget> messageItems = spaceMessages.chats
                  .where((item) => item.isTop == null || item.isTop == false)
                  .toList();
              if (!isExpand) {
                messageItems = messageItems
                    .where((item) => item.noRead != null && item.noRead != 0)
                    .toList();
              }
              var bottom = messageItems.isEmpty ? 0.h : 16.h;
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.only(bottom: bottom),
                itemCount: messageItems.length,
                itemBuilder: (context, index) {
                  MessageTarget messageItem = messageItems[index];
                  String spaceId = spaceMessages.id;
                  return MessageItemWidget(spaceId, messageItem);
                },
              );
            }
          },
        ),
      );
}
