import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/api_resp/message_item_resp.dart';
import 'package:orginone/api_resp/org_chat_cache.dart';
import 'package:orginone/component/unified_text_style.dart';
import 'package:orginone/page/home/message/component/message_item_widget.dart';

import '../../../../api_resp/space_messages_resp.dart';
import '../../../../component/unified_edge_insets.dart';
import '../message_controller.dart';

class GroupItemWidget extends GetView<MessageController> {
  final int index;

  const GroupItemWidget(this.index, {Key? key}) : super(key: key);

  get _title {
    var orgChatCache = controller.orgChatCache;
    var chat = orgChatCache.chats[index];
    var showCount = 0;
    if (chat.id == "topping") {
      for (var space in orgChatCache.chats) {
        var items = space.chats;
        for (var item in items) {
          if (item.isTop == true) {
            showCount++;
          }
        }
      }
    } else {
      showCount = chat.chats
          .where((item) => item.isTop == null || item.isTop == false)
          .length;
    }
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        chat.isExpand = !chat.isExpand;
        controller.update();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: ltb10,
            child: Text("${chat.name}($showCount)", style: text16),
          ),
          Container(
            padding: right10,
            child: GetBuilder<MessageController>(
              builder: (controller) {
                var iconData =
                    chat.isExpand ? Icons.arrow_drop_down : Icons.arrow_right;
                return Icon(iconData, size: 20.w);
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
            SpaceMessagesResp spaceMessages = orgChatCache.chats[index];
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
              var bottom = tops.isEmpty ? 0.h : 5.h;
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
              List<MessageItemResp> messageItems = spaceMessages.chats
                  .where((item) => item.isTop == null || item.isTop == false)
                  .toList();
              if (!isExpand) {
                messageItems = messageItems
                    .where((item) => item.noRead != null && item.noRead != 0)
                    .toList();
              }
              var bottom = messageItems.isEmpty ? 0.h : 5.h;
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.only(bottom: bottom),
                itemCount: messageItems.length,
                itemBuilder: (context, index) {
                  MessageItemResp messageItem = messageItems[index];
                  String spaceId = spaceMessages.id;
                  return MessageItemWidget(spaceId, messageItem);
                },
              );
            }
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
    if (controller.orgChatCache.chats[index].isExpand) {
      children.add(const Divider(height: 0));
    }
    return Column(children: children);
  }
}
