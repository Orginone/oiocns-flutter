import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:orginone/component/text_avatar.dart';
import 'package:orginone/page/home/message/chat/component/text_message.dart';
import 'package:orginone/util/hive_util.dart';

import '../../../../../api_resp/target_resp.dart';
import '../../../../../config/custom_colors.dart';
import '../../../../../enumeration/enum_map.dart';
import '../../../../../enumeration/message_type.dart';
import '../../../../../model/db_model.dart';

enum Direction { leftStart, rightStart }

class ChatMessageItem extends StatelessWidget {
  final MessageItem messageItem;
  final MessageDetail messageDetail;

  const ChatMessageItem(this.messageItem, this.messageDetail, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TargetResp userInfo = HiveUtil().getValue(Keys.userInfo);

    bool isMy = messageDetail.fromId == userInfo.id;
    String itemAvatarName = isMy ? userInfo.name : messageItem.name!;
    bool isMultiple = "群组" ==  messageItem.label || "公司" == messageItem.label;

    itemAvatarName = itemAvatarName
        .substring(0, messageItem.name!.length >= 2 ? 2 : 1)
        .toUpperCase();

    return isMy ? getMyChat(itemAvatarName, isMultiple) : getMyChat(itemAvatarName, isMultiple);
  }

  Widget getMyChat(String avatarName, bool isMultiple) {
    return Row(
      textDirection: TextDirection.rtl,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isMultiple? Container() : Container(),
        TextAvatar(avatarName),
        Container(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: _getMessage())
      ],
    );
  }

  Widget _getMessage() {
    MessageType messageType =
        EnumMap.messageTypeMap[messageDetail.msgType] ?? MessageType.unknown;

    switch (messageType) {
      case MessageType.text:
      case MessageType.unknown:
        return TextMessage(messageDetail.msgBody);
    }
  }
}
