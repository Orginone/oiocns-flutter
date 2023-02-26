import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/template/originone_scaffold.dart';
import 'package:orginone/components/template/tabs.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/dart/controller/chat/chat_controller.dart';
import 'package:orginone/pages/chat/message_page.dart';
import 'package:orginone/pages/other/home/components/user_bar.dart';
import 'package:orginone/pages/setting/set_home_page.dart';
import 'package:orginone/util/load_image.dart';
import 'package:orginone/util/sys_util.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SysUtil.setStatusBarBright();
    return OrginoneScaffold(
      resizeToAvoidBottomInset: false,
      appBarElevation: 0,
      appBarHeight: 0,
      body: TabsView(
        tabCtrl: controller.tabController,
        top: const UserBar(),
        views: controller.tabs.map((e) => e.toTabView()).toList(),
        bottom: TabBar(
          controller: controller.tabController,
          tabs: controller.tabs.map((item) => item.toTab()).toList(),
        ),
      ),
    );
  }
}

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}

class HomeController extends TabsController {
  var chatCtrl = Get.find<ChatController>();

  @override
  initTabs() {
    var size = Size(32.w, 32.w);
    registerTab(XTab(
      body: Text("沟通", style: XFonts.size14Black3),
      view: const MessagePage(),
      icon: XImage.localImage("chat", size: Size(38.w, 32.w)),
      children: [
        Positioned(
          top: 0,
          right: 0,
          child: Obx(() {
            var chatCtrl = Get.find<ChatController>();
            return chatCtrl.hasNoRead()
                ? Icon(Icons.circle, color: Colors.redAccent, size: 10.w)
                : Container();
          }),
        )
      ],
    ));
    registerTab(XTab(
      body: Text('办事', style: XFonts.size14Black3),
      view: Container(),
      icon: XImage.localImage("work", size: size),
    ));
    var center = XTab(
      body: XImage.localImage("logo_not_bg", size: Size(36.w, 36.w)),
      view: Container(),
      iconMargin: EdgeInsets.zero,
    );
    registerTab(center);
    registerTab(XTab(
      body: Text('仓库', style: XFonts.size14Black3),
      view: Container(),
      icon: XImage.localImage("warehouse", size: size),
    ));
    registerTab(XTab(
      body: Text('设置', style: XFonts.size14Black3),
      view: SetHomePage(),
      icon: XImage.localImage("setting", size: size),
    ));
    setIndex(tabs.indexOf(center));
  }
}
