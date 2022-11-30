import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:orginone/api_resp/message_detail.dart';
import 'package:orginone/component/text_avatar.dart';
import 'package:orginone/component/text_tag.dart';
import 'package:orginone/component/unified_colors.dart';
import 'package:orginone/component/unified_text_style.dart';
import 'package:orginone/controller/message/message_controller.dart';
import 'package:orginone/core/authority.dart';
import 'package:orginone/core/chat/chat_impl.dart';
import 'package:orginone/core/chat/i_chat.dart';
import 'package:orginone/enumeration/enum_map.dart';
import 'package:orginone/enumeration/message_type.dart';
import 'package:orginone/util/date_util.dart';
import 'package:orginone/util/string_util.dart';

double defaultAvatarWidth = 66.w;

enum ChatFunc {
  topping("置顶会话"),
  cancelTopping("取消置顶"),
  remove("删除会话");

  final String label;

  const ChatFunc(this.label);
}

class MessageItemWidget extends StatelessWidget {
  // 用户信息
  final IChat chat;
  final Function? onTap;

  const MessageItemWidget({
    Key? key,
    required this.chat,
    this.onTap,
  }) : super(key: key);

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
        final result = await showMenu(
          context: context,
          position: RelativeRect.fromLTRB(
            x,
            y - 50,
            MediaQuery.of(context).size.width - x,
            0,
          ),
          items: ChatFunc.values.map((item) {
            return PopupMenuItem(value: item, child: Text(item.label));
          }).toList(),
        );
      },
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
      child: Container(
        padding: EdgeInsets.only(left: 25.w, top: 16.h, right: 25.w),
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

  Widget _avatar() {
    int notRead = chat.noReadCount;
    Color badgeColor = chat.target.isInterruption ?? false
        ? UnifiedColors.cardBorder
        : GFColors.DANGER;
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: TextAvatar(
            avatarName: StringUtil.getAvatarName(
              avatarName: chat.target.name,
              type: TextAvatarType.chat,
            ),
            width: defaultAvatarWidth,
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: TextTag(chat.target.label),
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

  Widget _avatarContainer() {
    return Container(
      alignment: Alignment.center,
      width: defaultAvatarWidth,
      height: defaultAvatarWidth,
      child: Obx(() => _avatar()),
    );
  }

  Widget _content() {
    var messageItem = chat.target;
    var name = auth.userId == messageItem.id
        ? "${messageItem.name}（我）"
        : messageItem.name;

    var lastMessage = chat.lastMessage;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name, style: text22Bold),
            Text(
              CustomDateUtil.getSessionTime(lastMessage?.createTime),
              style: text18,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                _detailRemark(lastMessage),
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
              chat.spaceName,
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

  String _detailRemark(MessageDetail? detail) {
    if (detail == null) {
      return "";
    }
    var messageType = EnumMap.messageTypeMap;
    var type = messageType[detail.msgType] ?? MsgType.text;
    var messageCtrl = Get.find<MessageController>();

    var name = messageCtrl.getName(detail.fromId);
    var showTxt = "";
    if (chat is PersonChat) {
      if (detail.fromId != auth.userId) {
        showTxt = "对方：";
      }
    } else {
      showTxt = "$name:";
    }
    switch (type) {
      case MsgType.text:
        return "$showTxt${detail.msgBody ?? ""}";
      case MsgType.recall:
        return "$showTxt撤回了一条消息";
      case MsgType.image:
        return "$showTxt[图片]";
      case MsgType.voice:
        return "$showTxt[语音]";
      case MsgType.file:
        return "$showTxt[文件]";
      case MsgType.unknown:
      case MsgType.topping:
        return detail.msgBody ?? "";
    }
  }

  Widget _contentContainer() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(left: 20.w, top: 2.h, bottom: 2.h),
        height: defaultAvatarWidth,
        child: Obx(() => _content()),
      ),
    );
  }
}
