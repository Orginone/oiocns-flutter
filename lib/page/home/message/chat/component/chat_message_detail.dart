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

class ChatMessageDetail extends StatelessWidget {
  final MessageItem messageItem;
  final MessageDetail messageDetail;
  final TargetResp? targetResp;

  const ChatMessageDetail(this.messageItem, this.messageDetail, this.targetResp,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TargetResp userInfo = HiveUtil().getValue(Keys.userInfo);

    bool isMy = messageDetail.fromId == userInfo.id;
    String itemAvatarName = isMy ? userInfo.name : messageItem.name!;
    bool isMultiple = "群组" == messageItem.label || "公司" == messageItem.label;

    itemAvatarName = itemAvatarName
        .substring(0, messageItem.name!.length >= 2 ? 2 : 1)
        .toUpperCase();

    return getChat(itemAvatarName, isMy, isMultiple);
  }

  Widget getChat(String avatarName, bool isMy, bool isMultiple) {
    var targetName = targetResp?.name ?? "";
    return Row(
      textDirection: isMy ? TextDirection.rtl : TextDirection.ltr,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isMy
            ? TextAvatar(avatarName)
            : isMultiple
                ? TextAvatar(targetName
                    .substring(0, targetName.length >= 2 ? 2 : 1)
                    .toUpperCase())
                : TextAvatar(avatarName),
        isMy
            ? Container(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: _getMessage())
            : isMultiple
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0)),
                      Text(targetName),
                      Container(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: _getMessage())
                    ],
                  )
                : Container(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: _getMessage()),
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
