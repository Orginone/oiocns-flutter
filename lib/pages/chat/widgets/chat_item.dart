import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:orginone/common/routers/index.dart';
import 'package:orginone/components/index.dart';
import 'package:orginone/dart/base/model.dart' hide Column;
import 'package:orginone/dart/controller/index.dart';
import 'package:orginone/dart/core/chat/message.dart';
import 'package:orginone/dart/core/chat/session.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/utils/date_util.dart';
import 'package:orginone/utils/string_util.dart';
import 'package:orginone/config/unified.dart';

class MessageItemWidget extends GetView<IndexController> {
  // 用户信息
  final ISession chat;

  final bool enabledSlidable;

  const MessageItemWidget({
    Key? key,
    required this.chat,
    this.enabledSlidable = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isTop = chat.chatdata.value.labels.contains("置顶");
    return GestureDetector(
      onTap: () {
        chat.onMessage((messages) => null);
        Get.toNamed(
          Routers.messageChat,
          arguments: chat,
        );
      },
      child: Slidable(
        enabled: enabledSlidable,
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              icon: Icons.vertical_align_top,
              label: isTop ? "取消置顶" : "置顶",
              onPressed: (BuildContext context) async {
                if (isTop) {
                  chat.chatdata.value.labels.remove('置顶');
                } else {
                  chat.chatdata.value.labels.add('置顶');
                }
                await chat.cacheChatData();
                controller.provider.refresh();
              },
            ),
            SlidableAction(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: "删除",
              onPressed: (BuildContext context) {
                controller.chats.remove(chat);
                controller.provider.refresh();
              },
            ),
          ],
        ),
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 7.h),
            decoration: BoxDecoration(
                border: Border(
                    bottom:
                        BorderSide(color: Colors.grey.shade300, width: 0.4))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _avatarContainer,
                SizedBox(
                  width: 10.w,
                ),
                Expanded(child: Obx(() => _content)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget get _avatarContainer {
    return Obx(() {
      var noRead = '';
      Widget child = TeamAvatar(
        info: TeamTypeInfo(share: chat.share),
        size: 65.w,
        circular: chat.share.typeName == TargetType.person.label,
      );
      child = badges.Badge(
        ignorePointer: false,
        position: badges.BadgePosition.topEnd(top: -10),
        badgeContent: Text(
          noRead,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            letterSpacing: 1,
            wordSpacing: 2,
            height: 1,
          ),
        ),
        child: child,
      );
      return child;
    });
  }

  Widget get _content {
    var target = chat.chatdata;
    var labels = <Widget>[];
    for (var item in chat.chatdata.value.labels) {
      if (item.isNotEmpty) {
        bool isTop = item == "置顶";
        labels.add(TextTag(
          item,
          bgColor: Colors.white,
          textStyle: TextStyle(
            color: isTop ? XColors.fontErrorColor : XColors.designBlue,
            fontSize: 14.sp,
          ),
          borderColor: isTop ? XColors.fontErrorColor : XColors.tinyBlue,
        ));
        labels.add(Padding(padding: EdgeInsets.only(left: 4.w)));
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                target.value.chatName ?? "",
                style: TextStyle(
                  color: XColors.chatTitleColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 24.sp,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              ),
            ),
            Text(
              CustomDateUtil.getSessionTime(
                  chat.chatdata.value.lastMessage?.createTime),
              style: XFonts.chatSMTimeTip,
              textAlign: TextAlign.right,
            ),
          ],
        ),
        SizedBox(
          height: 3.h,
        ),
        Row(
          children: labels,
        ),
        SizedBox(
          height: 3.h,
        ),
        _showTxt(),
      ],
    );
  }

  Widget _showTxt() {
    var lastMessage = chat.chatdata.value.lastMessage;
    if (lastMessage == null) {
      return SizedBox(
        height: 30.h,
      );
    }
    return Builder(builder: (context) {
      var showTxt = "";
      if (lastMessage.fromId != controller.user?.metadata.id) {
        if (chat.share.typeName != TargetType.person.label) {
          var target = chat.members
              .firstWhere((element) => element.id == lastMessage.fromId);
          ShareIcon? shareIcon = target.shareIcon();
          showTxt = "${shareIcon?.name}:";
        } else {
          showTxt = "对方:";
        }
      }

      showTxt = showTxt +
          StringUtil.msgConversion(
              Message(lastMessage, chat), controller.user?.userId ?? "");

      return Text(
        showTxt,
        style: TextStyle(
          color: XColors.chatHintColors,
          fontSize: 18.sp,
        ),
        textAlign: TextAlign.left,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    });
  }
}
