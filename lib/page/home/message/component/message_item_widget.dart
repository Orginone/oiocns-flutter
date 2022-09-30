import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:orginone/api_resp/message_item_resp.dart';
import 'package:orginone/api_resp/space_messages_resp.dart';
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

class MessageItemWidget extends GetView<MessageController> {
  // 用户信息
  final String spaceId;
  final String messageItemId;
  final MessageItemResp messageItem;

  const MessageItemWidget(this.spaceId, this.messageItemId, this.messageItem,
      {Key? key})
      : super(key: key);

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
          StringUtil.removeHtml(messageItem.showTxt),
          style: text12Grey,
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPress: () {},
      onTap: () {
        Map<String, dynamic> args = {
          "messageItem": messageItem,
          "spaceId": spaceId,
          "messageItemId": messageItemId
        };
        Get.toNamed(Routers.chat, arguments: args);
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _avatarContainer(messageItem),
            _contentContainer(messageItem),
          ],
        ),
      ),
    );
  }
}
