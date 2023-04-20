import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/widget/template/originone_scaffold.dart';
import 'package:orginone/widget/template/tabs.dart';
import 'package:orginone/widget/unified.dart';
import 'package:orginone/widget/widgets/progress_dialog.dart';
import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/controller/chat/chat_controller.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/event/home_data.dart';
import 'package:orginone/main.dart';
import 'package:orginone/pages/chat/message_rent.dart';
import 'package:orginone/pages/other/home/components/user_bar.dart';
import 'package:orginone/pages/other/shop/view.dart';
import 'package:orginone/pages/other/ware_house/view.dart';
import 'package:orginone/pages/other/work/view.dart';
import 'package:orginone/pages/setting/version_page.dart';
import 'package:orginone/pages/setting/home/view.dart';
import 'package:orginone/util/common_tree_management.dart';
import 'package:orginone/util/department_management.dart';
import 'package:orginone/util/event_bus_helper.dart';
import 'package:orginone/util/file_management.dart';
import 'package:orginone/util/hive_utils.dart';
import 'package:orginone/util/load_image.dart';
import 'package:orginone/util/sys_util.dart';
import 'package:orginone/widget/loading_dialog.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:orginone/util/toast_utils.dart';

import 'function_page.dart';

DateTime? _lastCloseApp;

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SysUtil.setStatusBarBright();
    return WillPopScope(
      onWillPop: () async {
        if (_lastCloseApp == null ||
            DateTime.now().difference(_lastCloseApp!) > const Duration(seconds: 1)) {
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
        body: Tabs(
          tabCtrl: controller.tabController,
          top: const UserBar(),
          views: controller.tabs.map((e) => e.toTabView()).toList(),
          bottom: TabBar(
            controller: controller.tabController,
            tabs: controller.tabs.map((item) => item.toTab()).toList(),
            onTap: (index){
              controller.changeTab(index);
            },
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
    Get.lazyPut(() => UpdateController());
  }
}

class HomeController extends TabsController {
  var chatCtrl = Get.find<ChatController>();
  var updateCtrl = Get.find<UpdateController>();
  var settingCtrl = Get.find<SettingController>();

  @override
  initTabs() {
    var size = Size(32.w, 32.w);
    registerTab(XTab(
      body: Text("沟通", style: XFonts.size14Black3),
      view: const MessageRecent(),
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
      view: WorkPage(),
      icon: XImage.localImage("work", size: size),
    ));
    var center = XTab(
      body: XImage.localImage("logo_not_bg", size: Size(36.w, 36.w)),
      view: FunctionPage(),
      iconMargin: EdgeInsets.zero,
    );
    registerTab(center);
    registerTab(XTab(
      body: Text('仓库', style: XFonts.size14Black3),
      view: WareHousePage(),
      icon: XImage.localImage("warehouse", size: size),
    ));
    registerTab(XTab(
      body: Text('商店', style: XFonts.size14Black3),
      view: ShopPage(),
      icon: XImage.localImage("shop", size: size),
    ));
    setIndex(tabs.indexOf(center));
  }

  Future<void> loadData() async {
    try {
      if (KernelApi.getInstance().anystore.isOnline) {
        log('连接成功---------${KernelApi.getInstance().anystore.isOnline}');
        await Future.wait([
          DepartmentManagement().initDepartment(),
          CommonTreeManagement().initTree(),
          FileManagement().initFileDir(),
        ]);
        log('数据加载完成');
      } else {
        await Future.delayed(const Duration(milliseconds: 200), () async {
          log('尝试重新连接---------${KernelApi.getInstance().anystore.isOnline}');
          await initData();
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    EventBusHelper.register(this, (event) async {
      if (event is InitHomeData) {
        await initData();
      }
    });
  }

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
    await initData();
    _update();
  }

  Future<void> initData() async {
    LoadingDialog.showLoading(Get.context!,msg: "加载数据中");
    await loadData();
    LoadingDialog.dismiss(Get.context!);
  }

  _update() async{
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
    if(index!=settingCtrl.homeEnum.value.index){
      settingCtrl.setHomeEnum(HomeEnum.values[index]);
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    EventBusHelper.unregister(this);
  }
}
