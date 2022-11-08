import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:orginone/api_resp/message_item_resp.dart';
import 'package:orginone/component/a_font.dart';
import 'package:orginone/component/choose_item.dart';
import 'package:orginone/component/text_avatar.dart';
import 'package:orginone/component/unified_colors.dart';
import 'package:orginone/component/unified_scaffold.dart';
import 'package:orginone/logic/authority.dart';
import 'package:orginone/page/home/message/component/message_item_widget.dart';
import 'package:orginone/page/home/organization/cohorts/component/avatar_group.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/screen_init.dart';

import '../../../../enumeration/chat_type.dart';
import '../../../../enumeration/enum_map.dart';
import '../../../../util/string_util.dart';
import '../../../../util/widget_util.dart';
import 'message_setting_controller.dart';

Size defaultBtnSize = Size(400.w, 70.h);

class MessageSettingPage extends GetView<MessageSettingController> {
  const MessageSettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, ChatType> chatTypeMap = EnumMap.chatTypeMap;
    MessageItemResp item = controller.messageItem;
    ChatType chatType = chatTypeMap[item.label] ?? ChatType.unknown;

    List<Widget> children = [
      Align(alignment: Alignment.center, child: _body(chatType)),
    ];

    double interval = 28.h;
    double bottomDistance = interval;
    double left = (screenSize.width.w - defaultBtnSize.width) / 2;

    // 如果是群组,就有退出群组
    if (chatType == ChatType.group) {
      bottomDistance += interval + defaultBtnSize.height;
      children.add(Positioned(
        left: left,
        bottom: bottomDistance,
        child: _exitGroup(context),
      ));
    }

    // 个人空间的, 有特殊按钮
    if (item.spaceId == auth.userId) {
      // 如果是好友, 添加删除好友功能
      if (chatType == ChatType.friends) {
        bottomDistance += interval + defaultBtnSize.height;
        children.add(Positioned(
          left: left,
          bottom: bottomDistance,
          child: _removeFriend(context),
        ));
      }
      // 个人空间可以清空会话
      bottomDistance += interval + defaultBtnSize.height;
      children.add(Positioned(
        left: left,
        bottom: bottomDistance,
        child: _clear(context),
      ));
    }

    return UnifiedScaffold(
      appBarLeading: WidgetUtil.defaultBackBtn,
      appBarElevation: 0,
      body: Stack(children: children),
    );
  }

  Widget _body(ChatType chatType) {
    List<Widget> children = [];
    switch (chatType) {
      case ChatType.colleague:
      case ChatType.friends:
        children = [
          _avatar,
          Padding(padding: EdgeInsets.only(top: 50.h)),
          _interruption,
          _top,
          _searchChat,
        ];
        break;
      case ChatType.group:
      case ChatType.unit:
        var isRelationAdmin = auth.isRelationAdmin([controller.messageItemId]);
        children = [
          _avatar,
          Padding(padding: EdgeInsets.only(top: 50.h)),
          AvatarGroup(
            hasAdd: isRelationAdmin,
            showCount: isRelationAdmin ? 14 : 15,
            addCallback: () {
              Map<String, dynamic> args = {
                "spaceId": controller.spaceId,
                "messageItemId": controller.messageItemId
              };
              Get.toNamed(Routers.invite, arguments: args);
            },
          ),
          if (controller.hasReminder) _more,
          _interruption,
          _top,
          _searchChat,
        ];
        break;
      case ChatType.unknown:
        break;
    }
    return Container(
      padding: EdgeInsets.only(left: 30.w, right: 30.w),
      color: UnifiedColors.navigatorBgColor,
      child: ListView(children: children),
    );
  }

  get _more {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => Get.toNamed(Routers.moreCohort),
          child: Text("查看更多", style: AFont.instance.size20themeColorW500),
        ),
      ],
    );
  }

  /// 头像相关
  get _avatar {
    return GetBuilder<MessageSettingController>(builder: (controller) {
      var messageItem = controller.messageItem;
      var avatarName = StringUtil.getPrefixChars(messageItem.name, count: 1);
      var personNum = controller.messageItem.personNum;
      var name = "${messageItem.name}($personNum)";
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextAvatar(avatarName: avatarName, width: 60.w),
          Padding(padding: EdgeInsets.only(left: 10.w)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: AFont.instance.size22Black3W500),
              Text(messageItem.remark, style: AFont.instance.size16Black6)
            ],
          )
        ],
      );
    });
  }

  /// 消息免打扰
  get _interruption {
    return ChooseItem(
      padding: EdgeInsets.zero,
      header: Text(
        "消息免打扰",
        style: AFont.instance.size20Black3W500,
      ),
      operate: GetBuilder<MessageSettingController>(builder: (controller) {
        return Switch(
          value: controller.messageItem.isInterruption ?? false,
          onChanged: (value) {
            controller.interruptionOrNot(value);
          },
        );
      }),
    );
  }

  /// 置顶聊天
  get _top {
    return ChooseItem(
      padding: EdgeInsets.zero,
      header: Text(
        "置顶聊天",
        style: AFont.instance.size20Black3W500,
      ),
      operate: GetBuilder<MessageSettingController>(builder: (controller) {
        return Switch(
          value: controller.messageItem.isTop ?? false,
          onChanged: (value) async {
            var messageController = controller.messageController;
            var messageItem = controller.messageItem;
            var spaceId = controller.spaceId;
            var event = value ? ChatFunc.topping : ChatFunc.cancelTopping;

            await messageController.chatEventFire(event, spaceId, messageItem);
            controller.update();
          },
        );
      }),
    );
  }

  /// 查找聊天记录
  get _searchChat {
    return ChooseItem(
      padding: EdgeInsets.zero,
      header: Text(
        "查找聊天记录",
        style: AFont.instance.size20Black3W500,
      ),
      operate: Icon(
        Icons.keyboard_arrow_right,
        size: 32.w,
      ),
    );
  }

  /// 清空聊天记录
  Widget _clear(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all(defaultBtnSize),
        backgroundColor: MaterialStateProperty.all(UnifiedColors.themeColor),
      ),
      onPressed: () {
        showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: Text("您确定清空与${controller.messageItem.name}的聊天记录吗?"),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: const Text('取消'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                CupertinoDialogAction(
                  child: const Text('确定'),
                  onPressed: () async {
                    Navigator.pop(context);
                    await controller.clearHistoryMsg();
                    Fluttertoast.showToast(msg: "清空成功!");
                  },
                ),
              ],
            );
          },
        );
      },
      child: Text(
        "清空聊天记录",
        style: AFont.instance.size22WhiteW500,
      ),
    );
  }

  /// 删除好友
  Widget _removeFriend(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all(defaultBtnSize),
        backgroundColor: MaterialStateProperty.all(UnifiedColors.backColor),
      ),
      onPressed: () {
        showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: Text("您确定删除好友${controller.messageItem.name}吗?"),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: const Text('取消'),
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                ),
                CupertinoDialogAction(
                  child: const Text('确定'),
                  onPressed: () async {
                    Navigator.pop(context);
                    await controller.removeFriends();
                    Get.until((route) => route.settings.name == Routers.home);
                  },
                ),
              ],
            );
          },
        );
      },
      child: Text("删除好友", style: AFont.instance.size22WhiteW500),
    );
  }

  /// 删除好友
  Widget _exitGroup(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all(defaultBtnSize),
        backgroundColor: MaterialStateProperty.all(UnifiedColors.backColor),
      ),
      onPressed: () {
        showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: Text("您确定退出${controller.messageItem.name}吗?"),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: const Text('取消'),
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                ),
                CupertinoDialogAction(
                  child: const Text('确定'),
                  onPressed: () async {
                    Navigator.pop(context);
                    await controller.exitGroup();
                    Get.until((route) => route.settings.name == Routers.home);
                  },
                ),
              ],
            );
          },
        );
      },
      child: Text("退出群聊", style: AFont.instance.size22WhiteW500),
    );
  }
}
