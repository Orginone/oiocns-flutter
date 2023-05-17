import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:orginone/dart/core/chat/msgchat.dart';
import 'package:orginone/widget/unified.dart';
import 'package:orginone/widget/widgets/team_avatar.dart';
import 'package:orginone/widget/widgets/text_tag.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/date_util.dart';

enum ChatFunc {
  // topping("置顶会话"),
  // cancelTopping("取消置顶"),
  remove("删除会话");

  final String label;

  const ChatFunc(this.label);
}

class MessageItemWidget extends GetView<SettingController> {
  // 用户信息
  final IChat chat;

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
        Get.offNamedUntil(
          Routers.messageChat,
          (router) => router.settings.name == Routers.home,
          arguments: chat,
        );
      },
      child: Container(
        padding: EdgeInsets.only(left: 25.w, top: 16.h, right: 25.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _avatarContainer,
            Padding(padding: EdgeInsets.only(left: 20.w)),
            Expanded(child: Obx(() => _content)),
          ],
        ),
      ),
    );
  }

  Widget get _avatarContainer {
    return Obx(() {
      var noRead = chat.chatdata.value.noReadCount;
      return TeamAvatar(
        info: TeamTypeInfo(share: chat.shareInfo),
        children: [
          Visibility(
            visible: noRead > 0,
            child: Align(
              alignment: Alignment.topRight,
              child: GFBadge(
                shape: GFBadgeShape.circle,
                color: Colors.red,
                child: Text("${noRead > 99 ? "99+" : noRead}"),
              ),
            ),
          )
        ],
      );
    });
  }

  Widget get _content {
    var target = chat.chatdata.value;
    var labels = <Widget>[];
    for (var item in chat.chatdata.value.labels??[]) {
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(target.chatName??"", style: XFonts.size22Black0W700),
            Text(
              CustomDateUtil.getSessionTime(chat.chatdata.value.lastMessage?.createTime),
              style: XFonts.size18Black0,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Expanded(child: _showTxt()), ...labels],
        ),
      ],
    );
  }

  Widget _showTxt() {
    var lastMessage = chat.chatdata.value.lastMessage;
    if (lastMessage == null) {
      return Container();
    }
    var name = controller.user.findShareById(lastMessage.fromId);
    var showTxt = "";
    var settingCtrl = Get.find<SettingController>();
    if (lastMessage.fromId != settingCtrl.user.metadata.id) {
      showTxt = "对方:";
    }else {
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
}
