import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/api_resp/message_detail_resp.dart';
import 'package:orginone/api_resp/org_chat_cache.dart';
import 'package:orginone/component/text_avatar.dart';
import 'package:orginone/page/home/message/chat/chat_controller.dart';
import 'package:orginone/page/home/message/chat/component/text_message.dart';
import 'package:orginone/util/hive_util.dart';

import '../../../../../api_resp/target_resp.dart';
import '../../../../../component/unified_edge_insets.dart';
import '../../../../../component/unified_text_style.dart';
import '../../../../../enumeration/enum_map.dart';
import '../../../../../enumeration/message_type.dart';
import '../../../../../util/string_util.dart';

enum Direction { leftStart, rightStart }

enum DetailFunc {
  recall("撤回"),
  remove("删除");

  const DetailFunc(this.name);

  final String name;
}

class ChatMessageDetail extends GetView<ChatController> {
  final Logger log = Logger("ChatMessageDetail");

  final MessageDetailResp detail;
  final bool isMy;
  final bool isMultiple;

  ChatMessageDetail({
    required this.detail,
    required this.isMy,
    required this.isMultiple,
    Key? key,
  }) : super(key: key);

  String targetName() {
    OrgChatCache orgChatCache = controller.messageController.orgChatCache;
    return orgChatCache.nameMap[detail.fromId] ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return _messageDetail(context);
  }

  Widget _messageDetail(BuildContext context) {
    List<Widget> children = [];

    bool isRecall = detail.msgType == MsgType.recall.name;
    if (isRecall) {
      children.add(_getMessage());
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
        avatarName: isMy ? userInfo.team?.name ?? "" : targetName(),
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
          ),
        ),
      );
    }

    // 添加长按手势
    double x = 0, y = 0;
    String spaceId = controller.spaceId;
    String sessionId = controller.messageItemId;
    var chat = GestureDetector(
      onPanDown: (position) {
        x = position.globalPosition.dx;
        y = position.globalPosition.dy;
      },
      onLongPress: () async {
        List<DetailFunc> items = [];
        if (isMy && detail.createTime != null) {
          var diff = detail.createTime!.difference(DateTime.now());
          if (diff.inSeconds.abs() < 2 * 60) {
            items.add(DetailFunc.recall);
          }
        }
        TargetResp userInfo = HiveUtil().getValue(Keys.userInfo);
        if (spaceId == userInfo.id) {
          items.add(DetailFunc.remove);
        }
        if (items.isEmpty) {
          return;
        }
        var top = y - 50;
        var right = MediaQuery.of(context).size.width - x;
        final result = await showMenu<DetailFunc>(
          context: context,
          position: RelativeRect.fromLTRB(x, top, right, 0),
          items: items.map((item) {
            return PopupMenuItem(
              value: item,
              child: Text(item.name),
            );
          }).toList(),
        );
        if (result != null) {
          controller.detailFuncCallback(result, spaceId, sessionId, detail);
        }
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
    MsgType messageType =
        EnumMap.messageTypeMap[detail.msgType] ?? MsgType.unknown;

    TargetResp userInfo = HiveUtil().getValue(Keys.userInfo);
    switch (messageType) {
      case MsgType.recall:
        var messageItem = controller.messageItem;
        var nameMap = controller.messageController.orgChatCache.nameMap;
        String msgBody = StringUtil.getDetailRecallBody(messageItem, detail, nameMap);
        return Text(msgBody, style: text12Grey);
      default:
        return TextMessage(
          message: detail.msgBody,
          detail.fromId == userInfo.id ? TextDirection.rtl : TextDirection.ltr,
        );
    }
  }
}
