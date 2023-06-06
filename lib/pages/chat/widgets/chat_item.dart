import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/chat/message/msgchat.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/date_util.dart';
import 'package:orginone/util/string_util.dart';
import 'package:orginone/widget/unified.dart';
import 'package:orginone/widget/widgets/team_avatar.dart';
import 'package:orginone/widget/widgets/text_tag.dart';

enum ChatFunc {
  // topping("置顶会话"),
  // cancelTopping("取消置顶"),
  remove("删除会话");

  final String label;

  const ChatFunc(this.label);
}

class MessageItemWidget extends GetView<SettingController> {
  // 用户信息
  final IMsgChat chat;

  final bool enabledSlidable;

  const MessageItemWidget({
    Key? key,
    required this.chat,
    this.enabledSlidable = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isTop = chat.labels.contains("置顶");
    return GestureDetector(
      onTap: () {
        chat.onMessage();
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
              label:isTop?"取消置顶":"置顶",
              onPressed: (BuildContext context) {
                if(isTop){
                  chat.labels.remove('置顶');
                }else{
                  chat.labels.add('置顶');
                }
                controller.provider.refreshChat();
              },
            ),
            SlidableAction(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: "删除",
              onPressed: (BuildContext context) {
                controller.chat.allChats.remove(chat);
                controller.provider.refreshChat();
              },
            ),
          ],
        ),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
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
    );
  }

  Widget get _avatarContainer {
    return Obx(() {
      var noRead = chat.chatdata.value.noReadCount;
      Widget child = TeamAvatar(
        info: TeamTypeInfo(share: chat.share),
        size: 65.w,
        decoration:  chat.share.typeName == TargetType.person.label?const BoxDecoration(
          color: XColors.themeColor,
          shape: BoxShape.circle,
        ):null,
      );
      if (noRead > 0) {
        child = badges.Badge(
          ignorePointer: false,
          position: badges.BadgePosition.topEnd(top: -10),
          badgeContent: Text(
            "${noRead > 99 ? "99+" : noRead}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              letterSpacing: 1,
              wordSpacing: 2,
              height: 1,
            ),
          ),
          child:child,
        );
      }
      return child;
    });
  }

  Widget get _content {
    var target = chat.chatdata;
    var labels = <Widget>[];
    for (var item in chat.labels) {
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
              style: TextStyle(color: Colors.grey, fontSize: 18.sp),
              textAlign: TextAlign.right,
            ),
          ],
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
    return FutureBuilder<ShareIcon>(
        future: controller.user.findShareById(lastMessage.fromId),
        builder: (context, snapshot) {
          var showTxt = "";
          if (snapshot.connectionState == ConnectionState.done) {
            var name = snapshot.data?.name ?? "";
            if (lastMessage.fromId != controller.user.metadata.id) {
              if (chat.share.typeName != TargetType.person.label) {
                showTxt = "$name:";
              } else {
                showTxt = "对方:";
              }
            }

            showTxt =
                StringUtil.msgConversion(lastMessage, controller.user.userId);
          }

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
