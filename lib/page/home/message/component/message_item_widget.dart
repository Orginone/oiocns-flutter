import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:orginone/api_resp/message_target.dart';
import 'package:orginone/api_resp/target_resp.dart';
import 'package:orginone/component/text_tag.dart';
import 'package:orginone/component/unified_colors.dart';
import 'package:orginone/controller/message/message_controller.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/string_util.dart';

import '../../../../component/text_avatar.dart';
import '../../../../component/unified_text_style.dart';
import '../../../../logic/authority.dart';
import '../../../../util/date_util.dart';

double defaultAvatarWidth = 66.w;

enum ChatFunc {
  topping("置顶会话"),
  cancelTopping("取消置顶"),
  remove("删除会话");

  final String label;

  const ChatFunc(this.label);
}

class MessageItemWidget extends GetView<MessageController> {
  // 用户信息
  final String spaceId;
  final MessageTarget item;

  const MessageItemWidget(this.spaceId, this.item, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double x = 0, y = 0;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanDown: (position) {
        x = position.globalPosition.dx;
        y = position.globalPosition.dy;
      },
      onLongPress: () async {
        bool isTop = item.isTop ?? false;
        bool isRecent =
            controller.orgChatCache.recentChats?.contains(item) ?? false;
        List<ChatFunc> functions = [];
        if (isTop) {
          functions.add(ChatFunc.cancelTopping);
        } else {
          functions.add(ChatFunc.topping);
        }
        if (isRecent) functions.add(ChatFunc.remove);

        final result = await showMenu(
          context: context,
          position: RelativeRect.fromLTRB(
            x,
            y - 50,
            MediaQuery.of(context).size.width - x,
            0,
          ),
          items: functions
              .map((item) => PopupMenuItem(value: item, child: Text(item.label)))
              .toList(),
        );
        if (result != null) {
          controller.chatEventFire(result, spaceId, item);
        }
      },
      onTap: () {
        Map<String, dynamic> args = {
          "spaceId": spaceId,
          "messageItemId": item.id
        };
        Get.toNamed(Routers.chat, arguments: args);
      },
      child: Container(
        padding: EdgeInsets.only(left: 25.w, top: 16.h, right: 25.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _avatarContainer(item),
            _contentContainer(item),
          ],
        ),
      ),
    );
  }

  Widget _avatar(MessageTarget messageItem) {
    int notRead = messageItem.noRead ?? 0;
    Color badgeColor = messageItem.isInterruption ?? false
        ? UnifiedColors.cardBorder
        : GFColors.DANGER;
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: TextAvatar(
            avatarName: StringUtil.getAvatarName(
              avatarName: messageItem.name,
              type: TextAvatarType.chat,
            ),
            width: defaultAvatarWidth,
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: TextTag(messageItem.label),
        ),
        Visibility(
          visible: notRead > 0,
          child: Align(
            alignment: Alignment.topRight,
            child: GFBadge(
              color: badgeColor,
              child: Text("${notRead > 99 ? "99+" : notRead}"),
            ),
          ),
        )
      ],
    );
  }

  Widget _avatarContainer(MessageTarget messageItem) {
    return Container(
      alignment: Alignment.center,
      width: defaultAvatarWidth,
      height: defaultAvatarWidth,
      child: GetBuilder<MessageController>(
        builder: (controller) => _avatar(messageItem),
      ),
    );
  }

  Widget _content(MessageTarget messageItem) {
    Target userInfo = auth.userInfo;
    var name = userInfo.id == messageItem.id
        ? "${messageItem.name}（我）"
        : messageItem.name;

    var space = controller.spaceMap[messageItem.spaceId];
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name, style: text22Bold),
            Text(
              CustomDateUtil.getSessionTime(messageItem.msgTime),
              style: text18,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                messageItem.showTxt ?? "",
                style: TextStyle(
                  color: UnifiedColors.black9,
                  fontSize: 20.sp,
                ),
                textAlign: TextAlign.left,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            TextTag(
              space?.name ?? "",
              bgColor: Colors.white,
              textStyle: TextStyle(
                color: UnifiedColors.designBlue,
                fontSize: 12.sp,
              ),
              borderColor: UnifiedColors.tinyBlue,
            ),
          ],
        ),
      ],
    );
  }

  Widget _contentContainer(MessageTarget messageItem) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(left: 18.w, top: 2.h, bottom: 2.h),
        height: defaultAvatarWidth,
        child: GetBuilder<MessageController>(
          builder: (controller) => _content(messageItem),
        ),
      ),
    );
  }
}
