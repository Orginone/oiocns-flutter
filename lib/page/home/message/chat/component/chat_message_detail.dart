import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/api_resp/message_detail_resp.dart';
import 'package:orginone/api_resp/org_chat_cache.dart';
import 'package:orginone/component/text_avatar.dart';
import 'package:orginone/page/home/message/chat/chat_controller.dart';
import 'package:orginone/page/home/message/chat/component/chat_func.dart';
import 'package:orginone/page/home/message/chat/component/text_message.dart';
import 'package:orginone/util/hive_util.dart';
import 'package:orginone/util/string_util.dart';

import '../../../../../api_resp/target_resp.dart';
import '../../../../../component/popup_router.dart';
import '../../../../../component/unified_edge_insets.dart';
import '../../../../../component/unified_text_style.dart';
import '../../../../../enumeration/enum_map.dart';
import '../../../../../enumeration/message_type.dart';

enum Direction { leftStart, rightStart }

enum Func { recall, remove }

class ChatMessageDetail extends GetView<ChatController> {
  final Logger log = Logger("ChatMessageDetail");

  final String sessionId;
  final MessageDetailResp messageDetail;
  final bool isMy;
  final bool isMultiple;

  ChatMessageDetail(
      this.sessionId, this.messageDetail, this.isMy, this.isMultiple,
      {Key? key})
      : super(key: key);

  String targetName() {
    OrgChatCache orgChatCache = controller.messageController.orgChatCache;
    return orgChatCache.nameMap[messageDetail.fromId] ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return _messageDetail(context);
  }

  Widget _messageDetail(BuildContext context) {
    List<Widget> children = [];

    bool isRecall = false;
    if (messageDetail.msgType == "recall") {
      isRecall = true;
      String msgBody = "${targetName()}：撤回了一条信息";
      children.add(Text(msgBody, style: text12Grey));
    } else {
      children.add(_getAvatar());
      children.add(_getChat(context));
    }

    return Container(
      margin: top10,
      child: Row(
        textDirection: isMy ? TextDirection.rtl : TextDirection.ltr,
        mainAxisAlignment:
            isRecall ? MainAxisAlignment.center : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _getAvatar() {
    TargetResp userInfo = HiveUtil().getValue(Keys.userInfo);
    return TextAvatar(
      avatarName: StringUtil.getAvatarName(
        avatarName: isMy ? userInfo.team.name : targetName(),
        type: TextAvatarType.chat,
      ),
      textStyle: text12WhiteBold,
    );
  }

  Widget _getChat(BuildContext context) {
    List<Widget> content = <Widget>[];

    if (isMultiple && !isMy) {
      content.add(
        Container(
            margin: left10,
            child: Text(
              targetName(),
              style: text12,
            )),
      );
    }

    // 添加长按手势
    var chat = GestureDetector(
      onLongPress: () {
        if (!isMy) return;
        // _function(context, this);
      },
      child: _getMessage(),
    );
    content.add(chat);

    return Container(
      margin: isMy ? right2 : left2,
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
            message: messageDetail.msgBody,
            messageDetail.fromId == userInfo.id
                ? TextDirection.rtl
                : TextDirection.ltr);
    }
  }

  _function(BuildContext context, Widget item) {
    log.info("function");
    final RenderBox box = context.findRenderObject()! as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;
    const Offset offset = Offset.zero;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        box.localToGlobal(offset, ancestor: overlay),
        box.localToGlobal(box.size.bottomRight(Offset.zero) + offset,
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );
    showMenu<Func>(
      context: context,
      items: [
        CheckedPopupMenuItem(
          child: ChatFunc(messageDetail),
        )
      ],
      position: position,
    ).then<void>((Func? newValue) {
      controller.log.info("func${newValue?.name ?? ""}");
    });
  }
}
