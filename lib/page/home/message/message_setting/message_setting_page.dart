import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:orginone/api_resp/message_item_resp.dart';
import 'package:orginone/component/a_font.dart';
import 'package:orginone/component/choose_item.dart';
import 'package:orginone/component/form_item_type1.dart';
import 'package:orginone/component/text_avatar.dart';
import 'package:orginone/component/unified_colors.dart';
import 'package:orginone/component/unified_scaffold.dart';
import 'package:orginone/logic/authority.dart';
import 'package:orginone/page/home/message/component/message_item_widget.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/screen_init.dart';
import 'package:orginone/util/hub_util.dart';

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
      appBarBgColor: UnifiedColors.navigatorBgColor,
      appBarElevation: 0,
      body: Stack(children: children),
    );
  }

  Widget _body(ChatType chatType) {
    switch (chatType) {
      case ChatType.colleague:
      case ChatType.friends:
        return Container(
          padding: EdgeInsets.only(left: 30.w, right: 30.w),
          color: UnifiedColors.navigatorBgColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _avatar,
              Padding(padding: EdgeInsets.only(top: 50.h)),
              _container(_interruption),
              _container(_top),
              _container(_searchChat),
            ],
          ),
        );
      case ChatType.group:
        break;
      case ChatType.unit:
        break;
      case ChatType.unknown:
        Container(
          alignment: Alignment.center,
          child: Text(
            "未适配的类型",
            style: AFont.instance.size16Black3,
          ),
        );
        break;
    }

    return Obx(() {
      //拼接消息设置的界面,根据会话的标签分为个人,好友,单位,群组的概念
      List<Widget> widgetList = [
        Container(
          margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: FormItemType1(
            leftSlot: Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.all(Radius.circular(2))),
                margin: const EdgeInsets.all(10),
                alignment: Alignment.center,
                padding: const EdgeInsets.all(6),
                child: Text(
                  controller.messageItem.name.isNotEmpty
                      ? controller.messageItem.name.substring(
                          0, controller.messageItem.name.length >= 2 ? 2 : 1)
                      : '',
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                )),
            title: '群聊名称',
            text: controller.messageItem.name,
          ),
        ),
      ];
      return Container();
      // widgetList.add(personListWidget(typeName));
      // if (typeName == '群组') {
      //   widgetList.add(Container(
      //     margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      //     child: Column(
      //       children: [
      //         FormItemType2(
      //           text: "我在本群昵称",
      //           rightSlot: Text(
      //             controller.userInfo.name,
      //             style: const TextStyle(color: Colors.grey),
      //           ),
      //         ),
      //         FormItemType2(
      //           text: "备注",
      //           rightSlot: Text(
      //             controller.messageItem.remark,
      //             style: const TextStyle(color: Colors.grey),
      //           ),
      //         ),
      //       ],
      //     ),
      //   ));
      // }
      //
      // widgetList.add(btnListWidget(typeName));
      // return ListView(
      //   children: [
      //     Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: widgetList)
      //   ],
      // );
    });
  }

  /// 选择项包装器
  Widget _container(Widget child) {
    return Container(
      alignment: Alignment.center,
      height: 72.h,
      child: child,
    );
  }

  /// 头像相关
  get _avatar {
    var messageItem = controller.messageItem;
    var name = StringUtil.getPrefixChars(messageItem.name, count: 1);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextAvatar(avatarName: name, width: 60.w),
        Padding(padding: EdgeInsets.only(left: 10.w)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(messageItem.name, style: AFont.instance.size22Black3W500),
            Text(messageItem.remark, style: AFont.instance.size16Black6)
          ],
        )
      ],
    );
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
            controller.messageItem.isInterruption = value;
            HubUtil().cacheChats(controller.messageController.orgChatCache);
            controller.update();
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
          onChanged: (value) {
            var messageController = controller.messageController;
            var messageItem = controller.messageItem;
            var spaceId = controller.spaceId;
            var event = value ? ChatFunc.topping : ChatFunc.cancelTopping;

            messageController.chatEventFire(event, spaceId, messageItem);
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
                  onPressed: () {},
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
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                CupertinoDialogAction(
                  child: const Text('确定'),
                  onPressed: () async {
                    await controller.removeFriends();
                    Get.until((route) => route.settings.name == Routers.home);
                  },
                ),
              ],
            );
          },
        );
      },
      child: Text(
        "删除好友",
        style: AFont.instance.size22WhiteW500,
      ),
    );
  }

  //群组的widget
  Widget personListWidget(String type) {
    switch (type) {
      case '本人':
      case '好友':
        return Container();
      case '群组':
      case '单位':
        return Container(
          color: Colors.white,
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: Column(
            children: [
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        margin: const EdgeInsets.all(10),
                        child: Text(
                            "组成员 ${controller.originPersonList.length} 人",
                            style: const TextStyle(fontSize: 16))),
                    Container(
                      constraints: const BoxConstraints(
                          maxHeight: 40,
                          minHeight: 40,
                          minWidth: 50,
                          maxWidth: 150),
                      margin: const EdgeInsets.all(10),
                      child: TextField(
                          controller: controller.searchGroupTextController,
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  icon: const Icon(Icons.search),
                                  onPressed: () {
                                    controller.searchPerson();
                                  }),
                              contentPadding:
                                  const EdgeInsets.fromLTRB(10, 0, 0, 0),
                              enabledBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFFDCDFE6)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4.0)),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF409EFF)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4.0)),
                              ),
                              hintText: "搜索成员")),
                    )
                  ]),
              Container(
                height: 70,
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: type == '群组'
                        ? 2 + controller.filterPersonList.length
                        : controller.filterPersonList.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0 && type == '群组') {
                        return GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {},
                            child: Container(
                              height: 50,
                              margin: const EdgeInsets.fromLTRB(10, 1, 10, 20),
                              child: DottedBorder(
                                dashPattern: const [4, 4],
                                strokeWidth: 1,
                                padding: const EdgeInsets.all(0),
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 50,
                                  child: const Text("+",
                                      style: TextStyle(fontSize: 40)),
                                  // color: Colors.black26,
                                ),
                              ),
                            ));
                      } else if (index == 1 && type == '群组') {
                        return Container(
                          width: 50,
                          margin: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 1,
                                color: const Color.fromRGBO(255, 0, 0, 1)),
                          ),
                          child: const Text("-",
                              style:
                                  TextStyle(fontSize: 40, color: Colors.red)),
                        );
                      } else {
                        return GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            Get.toNamed(Routers.personDetail,
                                arguments: controller
                                    .filterPersonList[index].team?.code);
                          },
                          child: Container(
                            width: 50,
                            margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                FadeInImage.assetNetwork(
                                  placeholder: 'images/person-empty.png',
                                  image: 'qqqqqq',
                                  imageErrorBuilder:
                                      (context, error, stackTrace) {
                                    return Container(
                                      width: 50,
                                      height: 50,
                                      decoration: const BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'images/person-empty.png'),
                                              fit: BoxFit.cover)),
                                    );
                                  },
                                  width: 50,
                                  height: 50,
                                ),
                                Text(
                                    controller
                                        .filterPersonList[
                                            type == '群组' ? index - 2 : index]
                                        .name,
                                    style: const TextStyle(fontSize: 12),
                                    overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          ),
                        );
                      }
                    }),
              ),
              const Divider(
                height: 1,
              )
            ],
          ),
        );
    }
    return Container();
  }

  //按钮组的widget
  Widget btnListWidget(String type) {
    switch (type) {
      case '本人':
        return GFButton(
          size: 50,
          color: Colors.white,
          textStyle: const TextStyle(
              fontSize: 16, color: Color.fromRGBO(255, 0, 0, 1)),
          fullWidthButton: true,
          onPressed: () async {
            HubUtil().clearHistoryMsg(
              controller.spaceId,
              controller.messageItemId,
            );
          },
          text: "清空聊天记录",
        );
      case '好友':
        return Column(
          children: [
            GFButton(
              size: 50,
              color: Colors.white,
              textStyle: const TextStyle(
                  fontSize: 16, color: Color.fromRGBO(255, 0, 0, 1)),
              fullWidthButton: true,
              onPressed: () async {},
              text: "删除好友",
            ),
            const Divider(
              height: 1,
            ),
            GFButton(
              size: 50,
              color: Colors.white,
              textStyle: const TextStyle(
                  fontSize: 16, color: Color.fromRGBO(255, 0, 0, 1)),
              fullWidthButton: true,
              onPressed: () async {
                HubUtil().clearHistoryMsg(
                    controller.spaceId, controller.messageItemId);
              },
              text: "清空聊天记录",
            ),
          ],
        );
      case '群组':
        return Container();
      case '单位':
        return Container();
    }
    return Container();
  }
}
