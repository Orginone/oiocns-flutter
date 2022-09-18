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

import '../../../../component/text_avatar.dart';
import '../../../../component/unified_text_style.dart';
import '../../../../util/date_util.dart';
import '../../../../util/hive_util.dart';

double defaultAvatarWidth = 50.w;

class MessageItemWidget extends GetView<MessageController> {
  // 用户信息
  final int spaceId;
  final int messageItemId;
  final int index;

  const MessageItemWidget(this.spaceId, this.messageItemId, this.index,
      {Key? key})
      : super(key: key);

  Widget _avatar() {
    if (!controller.spaceMap.containsKey(spaceId)) {
      return Container();
    }

    SpaceMessagesResp spaceMessageItems = controller.spaceMap[spaceId]!;
    MessageItemResp messageItem = spaceMessageItems.chats[index];

    int notRead = messageItem.noRead ?? 0;
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: TextAvatar(
            avatarName: messageItem.name,
            type: TextAvatarType.chat,
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
            child: GFBadge(child: Text("$notRead")),
          ),
        )
      ],
    );
  }

  Widget _avatarContainer() {
    return Container(
      alignment: Alignment.center,
      width: defaultAvatarWidth,
      height: defaultAvatarWidth,
      child: GetBuilder<MessageController>(builder: (controller) => _avatar()),
    );
  }

  Widget _content() {
    if (!controller.spaceMap.containsKey(spaceId)) {
      return Container();
    }

    SpaceMessagesResp spaceMessageItems = controller.spaceMap[spaceId]!;
    MessageItemResp messageItem = spaceMessageItems.chats[index];

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
            Visibility(
              visible: messageItem.msgTime != null,
              child: Text(
                CustomDateUtil.getSessionTime(messageItem.msgTime),
                style: text12Grey,
              ),
            ),
          ],
        ),
        Text(
          messageItem.msgBody ?? "",
          style: text12Grey,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _contentContainer() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
        height: defaultAvatarWidth,
        child: GetBuilder<MessageController>(
          builder: (controller) => _content(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        MessageController messageController = Get.find();
        messageController.currentSpaceId = spaceId;
        messageController.currentMessageItemId = messageItemId;
        Get.toNamed(Routers.chat);
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _avatarContainer(),
            _contentContainer(),
          ],
        ),
      ),
    );
  }
}
