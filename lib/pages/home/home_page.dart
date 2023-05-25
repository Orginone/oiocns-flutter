import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/event/home_data.dart';
import 'package:orginone/pages/market/view.dart';
import 'package:orginone/pages/store/view.dart';
import 'package:orginone/widget/badge_widget.dart';
import 'package:orginone/widget/loading_dialog.dart';
import 'package:orginone/widget/template/originone_scaffold.dart';
import 'package:orginone/widget/template/tabs.dart';
import 'package:orginone/widget/unified.dart';
import 'package:orginone/widget/widgets/progress_dialog.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/main.dart';
import 'package:orginone/pages/chat/message_chats.dart';
import 'package:orginone/pages/home/components/user_bar.dart';
import 'package:orginone/pages/work/view.dart';
import 'package:orginone/pages/setting/version_page.dart';
import 'package:orginone/util/event_bus_helper.dart';
import 'package:orginone/util/sys_util.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:orginone/util/toast_utils.dart';
import 'index/index_pageV2.dart';

DateTime? _lastCloseApp;

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SysUtil.setStatusBarBright();
    return WillPopScope(
      onWillPop: () async {
        if (_lastCloseApp == null ||
            DateTime.now().difference(_lastCloseApp!) >
                const Duration(seconds: 1)) {
          _lastCloseApp = DateTime.now();
          ToastUtils.showMsg(msg: '再按一次退出');
          return false;
        }
        return true;
      },
      child: OrginoneScaffold(
        resizeToAvoidBottomInset: false,
        appBarElevation: 0,
        appBarHeight: 0,
        body: SafeArea(
          child: Tabs(
            tabCtrl: controller.tabController,
            top: const UserBar(),
            views: controller.tabs.map((e) => e.toTabView()).toList(),
            bottom: TabBar(
              indicator: const UnderlineTabIndicator(),
              controller: controller.tabController,
              tabs: controller.tabs.map((item) => item.toTab()).toList(),
              onTap: (index) {
                controller.changeTab(index);
              },
            ),
          ),
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
  var updateCtrl = Get.find<UpdateController>();
  var settingCtrl = Get.find<SettingController>();

  @override
  initTabs() {
    registerTab(XTab(
      view: const MessageChats(),
      tab: Obx(() {
        var chats = settingCtrl.provider.chat?.chats??[];
        int mgsCount = 0;
        for (var element in chats) {
          mgsCount += element.chatdata.value.noReadCount;
        }
        return BadgeTabWidget(
          imgPath: settingCtrl.homeEnum.value != HomeEnum.chat
              ? "unchat"
              : "chat",
          body: Text(HomeEnum.chat.label, style: XFonts.size15Black3),
          mgsCount: mgsCount,
        );
      }),
    ));
    registerTab(XTab(
      view: WorkPage(),
      tab: Obx(() {
        return BadgeTabWidget(
          imgPath: settingCtrl.homeEnum.value != HomeEnum.work
              ? "unwork"
              : 'work',
          body: Text(HomeEnum.work.label, style: XFonts.size15Black3),
          mgsCount: settingCtrl.provider.work?.todos.length ?? 0,
        );
      }),
    ));
    registerTab(XTab(
      view: const IndexTabPage(),
      tab: Obx(() {
        return BadgeTabWidget(
          imgPath: settingCtrl.homeEnum.value != HomeEnum.door
              ? "unhome"
              : "home",
          body: Text(HomeEnum.door.label, style: XFonts.size15Black3),
        );
      }),
    ));
    registerTab(XTab(
      view: StorePage(),
      tab: Obx(() {
        return BadgeTabWidget(
          imgPath: settingCtrl.homeEnum.value != HomeEnum.store
              ? "unstore"
              : "store",
          body: Text(HomeEnum.store.label, style: XFonts.size15Black3),
        );
      }),
    ));
    registerTab(XTab(
      view: MarketPage(),
      tab: Obx(() {
        return BadgeTabWidget(
          imgPath: settingCtrl.homeEnum.value != HomeEnum.market
              ? "unshop"
              : "shop",
          body: Text(HomeEnum.market.label, style: XFonts.size15Black3),
        );
      }),
    ));
  }


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    EventBusHelper.register(this, (event) async {
      if (event is ShowLoading) {
        if (event.isShow) {
          LoadingDialog.showLoading(Get.context!, msg: "加载数据中");
        } else {
          LoadingDialog.dismiss(Get.context!);
        }
      }
    });
  }

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
    _update();
  }


  _update() async {
    // 获取当前 apk 版本
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;

    // 弹出更新框
    var versionEntry = await updateCtrl.versionList();
    if (versionEntry != null && (versionEntry.versionMes ?? []).isNotEmpty) {
      //筛选出当前最新版本
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String appName = packageInfo.appName;
      int versionCode = int.parse(packageInfo.buildNumber);
      debugPrint("appName:$appName version:$version versionCode:$versionCode");
      for (VersionVersionMes element in (versionEntry.versionMes ?? [])) {
        if (appName == element.appName) {
          if (element.version! > versionCode) {
            //有新版本弹框提示
            showAnimatedDialog(
              context: navigatorKey.currentContext!,
              barrierDismissible: true,
              animationType: DialogTransitionType.fadeScale,
              builder: (BuildContext context) {
                return UpdaterDialog(
                  icon: element.uploadName?.shareLink ?? '',
                  version: "${element.version}",
                  path: element.shareLink ?? '',
                  content: element.remark ?? '',
                );
              },
            );
            break;
          }
        }
      }
    }
  }

  void changeTab(int index) {
    if (index != settingCtrl.homeEnum.value.index) {
      settingCtrl.setHomeEnum(HomeEnum.values[index]);
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    EventBusHelper.unregister(this);
  }

  @override
  int? initialIndex() {
    return 2;
  }
}
