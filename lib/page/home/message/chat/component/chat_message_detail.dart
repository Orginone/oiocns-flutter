import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/api_resp/message_item_resp.dart';
import 'package:orginone/component/text_avatar.dart';
import 'package:orginone/page/home/message/chat/component/chat_func.dart';
import 'package:orginone/page/home/message/chat/component/text_message.dart';
import 'package:orginone/util/hive_util.dart';

import '../../../../../api_resp/target_resp.dart';
import '../../../../../component/popup_router.dart';
import '../../../../../component/unified_edge_insets.dart';
import '../../../../../component/unified_text_style.dart';
import '../../../../../enumeration/enum_map.dart';
import '../../../../../enumeration/message_type.dart';
import '../../../../../model/db_model.dart';

enum Direction { leftStart, rightStart }

class ChatMessageDetail extends StatelessWidget {
  final Logger log = Logger("ChatMessageDetail");

  final MessageItemResp messageItem;
  final MessageDetail messageDetail;
  final TargetResp? targetResp;
  final Rx<bool> isWithdraw = false.obs;
  final Rx<String> msgBody = "".obs;

  ChatMessageDetail(this.messageItem, this.messageDetail, this.targetResp,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    isWithdraw.value = messageDetail.isWithdraw ?? false;
    msgBody.value = messageDetail.msgBody ?? "";

    TargetResp userInfo = HiveUtil().getValue(Keys.userInfo);
    bool isMy = messageDetail.fromId == userInfo.id;
    String itemAvatarName = isMy ? userInfo.name : messageItem.name!;
    bool isMultiple = "群组" == messageItem.label || "公司" == messageItem.label;

    itemAvatarName = itemAvatarName
        .substring(0, messageItem.name!.length >= 2 ? 2 : 1)
        .toUpperCase();

    return getChat(itemAvatarName, isMy, isMultiple, context, isWithdraw);
  }

  Widget getChat(String avatarName, bool isMy, bool isMultiple,
      BuildContext context, Rx<bool> isWithdraw) {
    return Obx(() {
      List<Widget> children = [];
      if (isWithdraw.value) {
        children.add(Text(msgBody.value, style: text12Grey));
      } else {
        children.add(_getAvatar(isMy, isMultiple, avatarName));
        children.add(_getChat(isMy, isMultiple, context, isWithdraw));
      }

      return Container(
          margin: topSmall,
          child: Row(
            textDirection: isMy ? TextDirection.rtl : TextDirection.ltr,
            mainAxisAlignment: isWithdraw.value
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ));
    });
  }

  Widget _getAvatar(bool isMy, bool isMultiple, String avatarName) {
    String name = !isMy && isMultiple ? targetResp?.name ?? "" : avatarName;
    return TextAvatar(
      avatarName: name,
      type: TextAvatarType.chat,
      textStyle: text12White,
    );
  }

  Widget _getChat(
      bool isMy, bool isMultiple, BuildContext context, Rx<bool> isWithdraw) {
    List<Widget> content = <Widget>[];
    if (isMultiple && !isMy) {
      var targetName = targetResp?.name ?? "";
      content.add(Text(targetName));
    }

    // 添加长按手势
    var chat = GestureDetector(
      onLongPress: () {
        if (!isMy) return;
        Navigator.push(
            context,
            NNPopupRoute(
                onClick: () {
                  Navigator.of(context).pop();
                },
                child: ChatFunc(messageDetail, isWithdraw)));
      },
      child: _getMessage(),
    );
    content.add(chat);

    return Container(
      margin: isMy
          ? const EdgeInsets.fromLTRB(0, 0, 5, 0)
          : const EdgeInsets.fromLTRB(5, 0, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: content,
      ),
    );
  }

  Widget _getMessage() {
    MessageType messageType =
        EnumMap.messageTypeMap[messageDetail.msgType] ?? MessageType.unknown;

    TargetResp userInfo = HiveUtil().getValue(Keys.userInfo);
    switch (messageType) {
      case MessageType.text:
      case MessageType.unknown:
        return TextMessage(
            messageDetail.msgBody,
            messageDetail.fromId == userInfo.id
                ? TextDirection.rtl
                : TextDirection.ltr);
    }
  }
}
