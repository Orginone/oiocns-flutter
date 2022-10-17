import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:keframe/keframe.dart';
import 'package:logging/logging.dart';
import 'package:orginone/api_resp/message_detail_resp.dart';
import 'package:orginone/api_resp/org_chat_cache.dart';
import 'package:orginone/component/text_avatar.dart';
import 'package:orginone/page/home/message/chat/chat_controller.dart';
import 'package:orginone/util/hive_util.dart';

import '../../../../../api_resp/target_resp.dart';
import '../../../../../component/unified_colors.dart';
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

double defaultWidth = 10.w;

class ChatMessageDetail extends GetView<ChatController> {
  final Logger log = Logger("ChatMessageDetail");

  final MessageDetailResp detail;
  final bool isMy;
  final bool isMultiple;
  final MsgType msgType;

  ChatMessageDetail({
    required this.detail,
    required this.isMy,
    required this.isMultiple,
    Key? key,
  })  : msgType = EnumMap.messageTypeMap[detail.msgType] ?? MsgType.unknown,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return _messageDetail(context);
  }

  /// 消息详情
  Widget _messageDetail(BuildContext context) {
    List<Widget> children = [];
    switch (msgType) {
      case MsgType.text:
      case MsgType.image:
      case MsgType.voice:
        children.add(_getAvatar());
        children.add(_getChat(context));
        break;
      case MsgType.recall:
        var messageItem = controller.messageItem;
        var nameMap = controller.messageController.orgChatCache.nameMap;
        String msgBody = StringUtil.getDetailRecallBody(
          item: messageItem,
          detail: detail,
          nameMap: nameMap,
        );
        children.add(Text(msgBody, style: text12Grey));
        break;
      default:
        break;
    }

    return Container(
      margin: top10,
      child: Row(
        textDirection: isMy ? TextDirection.rtl : TextDirection.ltr,
        mainAxisAlignment: msgType == MsgType.recall
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  /// 目标名称
  String targetName() {
    OrgChatCache orgChatCache = controller.messageController.orgChatCache;
    return orgChatCache.nameMap[detail.fromId] ?? "";
  }

  // 获取头像
  Widget _getAvatar() {
    TargetResp userInfo = HiveUtil().getValue(Keys.userInfo);
    return SizeCacheWidget(
      child: TextAvatar(
        avatarName: StringUtil.getAvatarName(
          avatarName: isMy ? userInfo.team?.name ?? "" : targetName(),
          type: TextAvatarType.chat,
        ),
        textStyle: text12WhiteBold,
      ),
    );
  }

  /// 获取会话
  Widget _getChat(BuildContext context) {
    List<Widget> content = <Widget>[];

    if (isMultiple && !isMy) {
      content.add(Container(
        margin: left10,
        child: Text(targetName(), style: text12),
      ));
    }

    TargetResp userInfo = HiveUtil().getValue(Keys.userInfo);

    Widget body;
    switch (msgType) {
      case MsgType.text:
        body = _detail(
          textDirection: detail.fromId == userInfo.id
              ? TextDirection.rtl
              : TextDirection.ltr,
          body: Text(
            detail.msgBody ?? "",
            style: text14Bold,
          ),
        );
        break;
      case MsgType.image:
        body = Image.network(
          "https://img2.baidu.com/it/u=676445988,3422842132&fm=253&app=120&size=w931&n=0&f=JPEG&fmt=auto?sec=1665680400&t=2450f6e5b2f1cbf9c22517f2fde94183",
          width: 100.w,
        );
        break;
      case MsgType.voice:
        body = _detail(
          textDirection: detail.fromId == userInfo.id
              ? TextDirection.rtl
              : TextDirection.ltr,
          body: Text(
            detail.msgBody ?? "",
            style: text14Bold,
          ),
        );
        break;
      default:
        body = Container();
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
      child: body,
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

  /// 会话详情
  Widget _detail({required TextDirection textDirection, required Widget body}) {
    return Container(
      constraints: BoxConstraints(maxWidth: 180.w),
      padding: EdgeInsets.all(defaultWidth),
      margin: textDirection == TextDirection.ltr
          ? EdgeInsets.only(left: defaultWidth, top: defaultWidth / 2)
          : EdgeInsets.only(right: defaultWidth, top: defaultWidth / 2),
      decoration: BoxDecoration(
        color: UnifiedColors.seaBlue,
        borderRadius: BorderRadius.all(Radius.circular(defaultWidth)),
      ),
      child: body,
    );
  }
}
