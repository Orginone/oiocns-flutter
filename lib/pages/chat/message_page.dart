import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/template/choose_item.dart';
import 'package:orginone/components/template/tabs.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/dart/controller/chat/chat_controller.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/pages/chat/widgets/message_item_widget.dart';
import 'package:orginone/routers.dart';

class MessagePage extends GetView<MessageController> {
  const MessagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tabs(
      tabCtrl: controller.tabController,
      top: TabBar(
        controller: controller.tabController,
        tabs: controller.tabs.map((item) => item.toTab()).toList(),
      ),
      views: controller.tabs.map((item) => item.toTabView()).toList(),
    );
  }
}

class MessageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MessageController());
  }
}

class MessageController extends TabsController {
  var chatCtrl = Get.find<ChatController>();

  @override
  initTabs() {
    registerTab(XTab(
      view: const Recent(),
      body: Container(
        alignment: Alignment.center,
        width: 100.w,
        child: Text("会话", style: XFonts.size22Black3),
      ),
      children: [
        Positioned(
          top: 0,
          right: 0,
          child: Obx(() => chatCtrl.hasNoRead()
              ? Icon(Icons.circle, color: Colors.redAccent, size: 10.w)
              : Container()),
        )
      ],
    ));
    registerTab(XTab(
      view: const Relation(),
      body: Text("通讯录", style: XFonts.size22Black3),
    ));
  }
}

class Recent extends GetView<ChatController> {
  const Recent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      int chatSize = controller.getChatSize();
      return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: chatSize + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index < chatSize) {
            var chat = controller.chats[index];
            return MessageItemWidget(chat: chat, remove: controller.removeChat);
          }
          return GestureDetector(
            onTap: () {
              Get.toNamed(Routers.moreMessage);
            },
            child: Column(
              children: [
                Padding(padding: EdgeInsets.only(top: 30.h)),
                Text("更多会话", style: XFonts.size18Theme),
                Padding(padding: EdgeInsets.only(top: 30.h)),
              ],
            ),
          );
        },
      );
    });
  }
}

class Relation extends GetView<ChatController> {
  const Relation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _relation();
  }

  Widget _relation() {
    List<Widget> children = [];
    children.add(Padding(padding: EdgeInsets.only(top: 10.h)));
    children.add(Divider(height: 1.h));
    children.add(Padding(padding: EdgeInsets.only(top: 10.h)));
    children.add(_links());
    return Container(
      margin: EdgeInsets.only(left: 25.w, right: 25.w),
      child: Column(children: children),
    );
  }

  Widget _links() {
    double top = 12.h;
    return Column(
      children: [
        Padding(padding: EdgeInsets.only(top: top)),
        _myRelation,
        Padding(padding: EdgeInsets.only(top: top)),
        _myCohort,
      ],
    );
  }

  Widget _header(IconData icon) {
    return AdvancedAvatar(
      size: 60.w,
      decoration: BoxDecoration(
        color: XColors.themeColor,
        borderRadius: BorderRadius.all(Radius.circular(8.w)),
      ),
      child: Icon(icon, color: Colors.white),
    );
  }

  get _otherUnits => ChooseItem(
        padding: EdgeInsets.zero,
        header: _header(Icons.group),
        body: Container(
          margin: EdgeInsets.only(left: 15.w),
          child: Text("其他单位", style: XFonts.size22Black3W700),
        ),
        func: () {
          Get.toNamed(Routers.mineUnit);
        },
      );

  get _myRelation => ChooseItem(
        padding: EdgeInsets.zero,
        header: _header(Icons.group),
        body: Container(
          margin: EdgeInsets.only(left: 15.w),
          child: Text("我的好友", style: XFonts.size22Black3W700),
        ),
        func: () {
          Get.toNamed(Routers.contact);
        },
      );

  get _myCohort => ChooseItem(
        padding: EdgeInsets.zero,
        header: _header(Icons.group),
        body: Container(
          margin: EdgeInsets.only(left: 15.w),
          child: Text("我的群组", style: XFonts.size22Black3W700),
        ),
        func: () {
          if (Get.isRegistered<SettingController>()) {
            var settingCtrl = Get.find<SettingController>();
            settingCtrl.user?.getCohorts();
          }
          Get.toNamed(Routers.cohorts);
        },
      );
}
