import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/components/widgets/text_avatar.dart';
import 'package:orginone/components/widgets/text_tag.dart';
import 'package:orginone/dart/controller/chat/chat_controller.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/chat/chat.dart';
import 'package:orginone/dart/core/chat/ichat.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/date_util.dart';

double defaultAvatarWidth = 66.w;

enum ChatFunc {
  // topping("置顶会话"),
  // cancelTopping("取消置顶"),
  remove("删除会话");

  final String label;

  const ChatFunc(this.label);
}

class MessageItemWidget extends GetView<ChatController> {
  // 用户信息
  final IChat chat;
  final Function? remove;

  const MessageItemWidget({
    Key? key,
    required this.chat,
    this.remove,
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
              if (remove != null) {
                remove!(chat);
              }
              break;
          }
        }
      },
      onTap: () async {
        if (Get.isRegistered<ChatController>()) {
          var chatCtrl = Get.find<ChatController>();
          await chatCtrl.setCurrent(chat.spaceId, chat.chatId);
          Get.offNamedUntil(
            Routers.chat,
            (router) => router.settings.name == Routers.home,
          );
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
    var noRead = chat.noReadCount.value;
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: TextAvatar(
            avatarName: chat.target.name.substring(0, 2),
            width: defaultAvatarWidth,
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: TextTag(chat.target.label ?? ""),
        ),
        Visibility(
          visible: noRead > 0,
          child: Align(
            alignment: Alignment.topRight,
            child: GFBadge(
              color: XColors.cardBorder,
              child: Text("${noRead > 99 ? "99+" : noRead}"),
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
    var target = chat.target;
    var lastMessage = chat.lastMessage;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(target.name, style: XFonts.size22Black0W700),
            Text(
              CustomDateUtil.getSessionTime(lastMessage.value?.createTime),
              style: XFonts.size18Black0,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: _showTxt()),
            TextTag(
              chat.spaceName,
              bgColor: Colors.white,
              textStyle: TextStyle(
                color: XColors.designBlue,
                fontSize: 12.sp,
              ),
              borderColor: XColors.tinyBlue,
            ),
          ],
        ),
      ],
    );
  }

  Widget _showTxt() {
    var lastMessage = chat.lastMessage.value;
    if (lastMessage == null) {
      return Container();
    }
    var name = controller.getName(lastMessage.fromId);
    var showTxt = "";
    if (chat is PersonChat) {
      var settingCtrl = Get.find<SettingController>();
      if (lastMessage.fromId != settingCtrl.user!.target.id) {
        showTxt = "对方:";
      }
    } else {
      showTxt = "$name:";
    }

    var messageType = lastMessage.msgType;
    if (messageType == MessageType.text.label) {
      showTxt = "$showTxt${lastMessage.showTxt}";
    } else if (messageType == MessageType.recall.label) {
      showTxt = "$showTxt撤回了一条消息";
    } else if (messageType == MessageType.image.label) {
      showTxt = "$showTxt[图片]";
    } else if (messageType == MessageType.video.label) {
      showTxt = "$showTxt[视频]";
    } else if (messageType == MessageType.voice.label) {
      showTxt = "$showTxt[语音]";
    }

    return Text(
      showTxt,
      style: TextStyle(
        color: XColors.black9,
        fontSize: 20.sp,
      ),
      textAlign: TextAlign.left,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
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
