import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/component/a_font.dart';
import 'package:orginone/component/choose_item.dart';
import 'package:orginone/component/text_avatar.dart';
import 'package:orginone/component/unified_colors.dart';
import 'package:orginone/component/unified_scaffold.dart';
import 'package:orginone/controller/message/message_controller.dart';
import 'package:orginone/core/authority.dart';
import 'package:orginone/core/chat/i_chat.dart';
import 'package:orginone/enumeration/chat_type.dart';
import 'package:orginone/enumeration/enum_map.dart';
import 'package:orginone/enumeration/target_type.dart';
import 'package:orginone/page/home/organization/cohorts/component/avatar_group.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/screen_init.dart';
import 'package:orginone/util/string_util.dart';
import 'package:orginone/util/widget_util.dart';

Size defaultBtnSize = Size(400.w, 70.h);

class MessageSettingPage extends GetView<MessageController> {
  const MessageSettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, ChatType> chatTypeMap = EnumMap.chatTypeMap;
    IChat chat = controller.getCurrentSetting!;
    ChatType chatType = chatTypeMap[chat.target.label] ?? ChatType.unknown;

    List<Widget> children = [
      Align(alignment: Alignment.center, child: _body(chatType)),
    ];

    double interval = 28.h;
    double bottomDistance = interval;
    double left = (screenSize.width.w - defaultBtnSize.width) / 2;

    // 如果是群组,就有退出群组
    if (chatType == ChatType.cohort || chatType == ChatType.jobCohort) {
      bottomDistance += interval + defaultBtnSize.height;
      children.add(Positioned(
        left: left,
        bottom: bottomDistance,
        child: _exitTarget(context, chatType.label),
      ));
    }

    // 个人空间的, 有特殊按钮
    if (chat.spaceId == auth.userId) {
      // 如果是好友, 添加删除好友功能
      if (chatType == ChatType.friends) {
        bottomDistance += interval + defaultBtnSize.height;
        children.add(Positioned(
          left: left,
          bottom: bottomDistance,
          child: _exitTarget(context, chatType.label),
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
    IChat chat = controller.getCurrentSetting!;
    List<Widget> children = [];
    switch (chatType) {
      case ChatType.self:
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
      case ChatType.cohort:
      case ChatType.jobCohort:
      case ChatType.unit:
        var isRelationAdmin = auth.isRelationAdmin([chat.chatId]);
        children = [
          _avatar,
          Padding(padding: EdgeInsets.only(top: 50.h)),
          Obx(() {
            controller.log.info(
                "当前群人员数量：${controller.getCurrentSetting!.persons.length}");
            return AvatarGroup(
              persons: controller.getCurrentSetting!.persons,
              hasAdd: isRelationAdmin,
              showCount: isRelationAdmin ? 14 : 15,
              addCallback: () {
                Map<String, dynamic> args = {
                  "spaceId": chat.spaceId,
                  "messageItemId": chat.chatId
                };
                Get.toNamed(Routers.invite, arguments: args);
              },
            );
          }),
          if (chat.hasMorePersons()) _more,
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
    return Obx(() {
      var chat = controller.getCurrentSetting!;
      var messageItem = chat.target;
      var avatarName = StringUtil.getPrefixChars(messageItem.name, count: 1);
      String name = messageItem.name;
      if (messageItem.typeName != TargetType.person.label) {
        name += "(${chat.personCount})";
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextAvatar(avatarName: avatarName, width: 60.w),
          Padding(padding: EdgeInsets.only(left: 10.w)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: AFont.instance.size22Black3W500),
              Text(messageItem.remark ?? "", style: AFont.instance.size16Black6)
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
      operate: Switch(value: false, onChanged: (value) {}),
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
      operate: Switch(
        value: false,
        onChanged: (value) {},
      ),
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
              title: Text(
                  "您确定清空与${controller.getCurrentSetting?.target.name}的聊天记录吗?"),
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
                    await controller.getCurrentSetting?.clearMessage();
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
  Widget _exitTarget(BuildContext context, String targetType) {
    String remark = "";
    String btnName = "";
    if (targetType == TargetType.cohort.label || targetType == TargetType.jobCohort.label) {
      remark = "您确定退出${controller.getCurrentChat?.target.name}吗?";
      btnName = "退出群聊";
    } else if (targetType == TargetType.person.label) {
      remark = "您确定删除好友${controller.getCurrentSetting?.target.name}吗?";
      btnName = "删除好友";
    }
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
              title: Text(remark),
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
                    await controller.exitCurrentTarget();
                    Get.until((route) => route.settings.name == Routers.home);
                  },
                ),
              ],
            );
          },
        );
      },
      child: Text(btnName, style: AFont.instance.size22WhiteW500),
    );
  }
}
