import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:orginone/api_resp/message_item_resp.dart';
import 'package:orginone/api_resp/target_resp.dart';
import 'package:orginone/component/text_tag.dart';
import 'package:orginone/page/home/message/message_controller.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/string_util.dart';

import '../../../../component/text_avatar.dart';
import '../../../../component/unified_text_style.dart';
import '../../../../util/date_util.dart';
import '../../../../util/hive_util.dart';

double defaultAvatarWidth = 50.w;

enum LongPressFunc {
  topping("置顶会话", "false"),
  cancelTopping("取消置顶", "true");

  final String name;
  final String isTopFunc;

  const LongPressFunc(this.name, this.isTopFunc);
}

class MessageItemWidget extends GetView<MessageController> {
  // 用户信息
  final String spaceId;
  final MessageItemResp item;

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
        String isTop = "${item.isTop ?? false}";
        final result = await showMenu(
          context: context,
          position: RelativeRect.fromLTRB(
              x, y - 50, MediaQuery.of(context).size.width - x, 0),
          items: LongPressFunc.values
              .where((item) => isTop == item.isTopFunc)
              .map((item) => PopupMenuItem(value: item, child: Text(item.name)))
              .toList(),
        );
        if (result != null) {
          controller.funcCallback(result, spaceId, item);
        }
      },
      onTap: () {
        Map<String, dynamic> args = {
          "messageItem": item,
          "spaceId": spaceId,
          "messageItemId": item.id
        };
        Get.toNamed(Routers.chat, arguments: args);
      },
      child: Container(
        padding: EdgeInsets.only(left: 10.w, top: 5.h, right: 10.w),
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

  Widget _avatar(MessageItemResp messageItem) {
    int notRead = messageItem.noRead ?? 0;
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
          child: TextTag(messageItem.typeName),
        ),
        Visibility(
          visible: notRead > 0,
          child: Align(
            alignment: Alignment.topRight,
            child: GFBadge(child: Text("${notRead > 99 ? "99+" : notRead}")),
          ),
        )
      ],
    );
  }

  Widget _avatarContainer(MessageItemResp messageItem) {
    return Container(
      alignment: Alignment.center,
      width: defaultAvatarWidth,
      height: defaultAvatarWidth,
      child: GetBuilder<MessageController>(
        builder: (controller) => _avatar(messageItem),
      ),
    );
  }

  Widget _content(MessageItemResp messageItem) {
    TargetResp userInfo = HiveUtil().getValue(Keys.userInfo);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              userInfo.id == messageItem.id
                  ? "${messageItem.name}（我）"
                  : messageItem.name,
              style: text16Bold,
            ),
            Text(
              CustomDateUtil.getSessionTime(messageItem.msgTime),
              style: text12Grey,
            ),
          ],
        ),
        Text(
          (messageItem.showTxt ?? "").replaceAll("", "\u200B"),
          style: text12Grey,
          textAlign: TextAlign.left,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _contentContainer(MessageItemResp messageItem) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
        height: defaultAvatarWidth,
        child: GetBuilder<MessageController>(
          builder: (controller) => _content(messageItem),
        ),
      ),
    );
  }
}
