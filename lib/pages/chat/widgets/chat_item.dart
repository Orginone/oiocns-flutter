import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/chat/message/msgchat.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/pages/chat/text_replace_utils.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/date_util.dart';
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

  const MessageItemWidget({
    Key? key,
    required this.chat,
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
        if (result != null) {
          switch (result) {
            case ChatFunc.remove:
              break;
          }
        }
      },
      onTap: () async {
        chat.onMessage();
        Get.toNamed(
          Routers.messageChat,
          arguments: chat,
        );
      },
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
    );
  }

  Widget get _avatarContainer {
    return Obx(() {
     ;
      var noRead = chat.chatdata.value.noReadCount;
      Widget child = TeamAvatar(
        info: TeamTypeInfo(share: chat.share),
        size: 60.w,
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
    for (var item in chat.chatdata.value.labels) {
      if(item.isNotEmpty){
        labels.add(TextTag(
          item,
          bgColor: Colors.white,
          textStyle: TextStyle(
            color: XColors.designBlue,
            fontSize: 12.sp,
          ),
          borderColor: XColors.tinyBlue,
        ));
        labels.add(Padding(padding: EdgeInsets.only(left: 4.w)));
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(target.value.chatName ?? "",
                style: TextStyle(
                    color: XColors.chatTitleColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 21.sp)),
            SizedBox(
              width: 10.w,
            ),
            ...labels,
            Expanded(
              child: Text(
                CustomDateUtil.getSessionTime(
                    chat.chatdata.value.lastMessage?.createTime),
                style: TextStyle(color: Colors.grey, fontSize: 18.sp),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        SizedBox(height: 3.h,),
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
              if(chat.share.typeName != TargetType.person.label){
                showTxt = "$name:";
              }else{
                showTxt = "对方:";
              }
            }

            var messageType = lastMessage.msgType;
            if (messageType == MessageType.text.label) {
              var userIds = TextUtils.findUserId(lastMessage.showTxt);
              if(userIds.isNotEmpty && userIds.contains(controller.user.userId)){
                showTxt = "有人@你";
              }else{
                showTxt = "$showTxt${TextUtils.textReplace(lastMessage.showTxt)}";
              }
            } else if (messageType == MessageType.recall.label) {
              showTxt = "$showTxt撤回了一条消息";
            } else if (messageType == MessageType.image.label) {
              showTxt = "$showTxt[图片]";
            } else if (messageType == MessageType.video.label) {
              showTxt = "$showTxt[视频]";
            } else if (messageType == MessageType.voice.label) {
              showTxt = "$showTxt[语音]";
            } else if (messageType == MessageType.file.label) {
              showTxt = "$showTxt[文件]";
            }
          }

          return Text(
            showTxt,
            style: TextStyle(
              color: XColors.chatHintColors,
              fontSize: 17.sp,
            ),
            textAlign: TextAlign.left,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
        });
  }
}
