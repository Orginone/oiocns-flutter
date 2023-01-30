import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_treeview/flutter_treeview.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/components/bread_crumb.dart';
import 'package:orginone/components/progress_dialog.dart';
import 'package:orginone/components/tab_combine.dart';
import 'package:orginone/components/unified_text_style.dart';
import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/base/model/version_entity.dart';
import 'package:orginone/dart/controller/file_controller.dart';
import 'package:orginone/dart/controller/message/message_controller.dart';
import 'package:flutter_treeview/flutter_treeview.dart' as tree_view;
import 'package:orginone/pages/chat/message_page.dart';
import 'package:orginone/pages/market/application/page/application_page.dart';
import 'package:orginone/pages/other/center/center_page.dart';
import 'package:orginone/pages/setting/mine/set_home/set_home_page.dart';
import 'package:orginone/pages/setting/organization/organization_controller.dart';
import 'package:orginone/pages/work/affairs/affairs_page.dart';
import 'package:orginone/util/load_image.dart';
import 'package:orginone/main.dart';
import 'package:package_info_plus/package_info_plus.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  Logger log = Logger("HomeController");

  var messageCtrl = Get.find<MessageController>();
  var organizationCtrl = Get.find<OrganizationController>();
  var fileCtrl = Get.find<FileController>();

  /// 全局面包屑
  var breadCrumbController = BreadCrumbController<String>(topNode: topPoint);

  /// Tab 控制器
  late List<TabCombine> tabs;
  late TabController tabController;
  late RxInt tabIndex;
  late TabCombine message, relation, center, work, my;

  /// 路由切换
  late RxBool routerOpened;
  late TreeViewController treeViewController;

  @override
  void onInit() {
    super.onInit();
    _initTabs();
    _initRouter();
  }

  _initRouter() {
    routerOpened = false.obs;

    Queue<Item<String>> queue = Queue.of(topPoint.children);
    Map<String, tree_view.Node<Item<String>>> map = {};
    List<tree_view.Node<Item<String>>> ans = [];
    while (queue.isNotEmpty) {
      var point = queue.removeFirst();
      var node = tree_view.Node(
        key: point.id,
        label: point.label,
        data: point,
        children: [],
      );
      map[point.id] = node;
      if (point.parent == topPoint) {
        ans.add(node);
      } else {
        var parentNode = map[point.parent!.id];
        parentNode!.children.add(node);
      }
      queue.addAll(point.children);
    }

    treeViewController = TreeViewController(children: ans);
  }

  @override
  void onReady() async {
    super.onReady();

    // 获取当前 apk 版本
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;

    // 获取当前上传的 apk 版本
    Map<String, dynamic> apkDetail = await fileCtrl.apkDetail();

    // 弹出更新框
    if (apkDetail["version"] != version) {
      var versionEntry = await fileCtrl.versionList();
      if (versionEntry != null && (versionEntry.versionMes ?? []).isNotEmpty) {
        //筛选出当前最新版本
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        String appName = packageInfo.appName;
        int versionCode = int.parse(packageInfo.buildNumber);
        debugPrint("appName:$appName versionCode:$versionCode");
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
            }
          }
        }
      }
    }
  }

  @override
  void onClose() {
    super.onClose();
    Kernel.getInstance.stop();
    breadCrumbController.dispose();
    tabController.dispose();
  }

  void _initTabs() {
    var size = Size(32.w, 32.w);
    message = TabCombine(
      customTab: _buildTabTick(
          AImage.localImage(
            "chat",
            size: Size(38.w, 32.w),
          ),
          "沟通"),
      tabView: const MessagePage(),
      breadCrumbItem: chatPoint,
    );
    relation = TabCombine(
      body: Text('办事', style: text14),
      tabView: const AffairsPage(),
      icon: AImage.localImage("work", size: size),
      breadCrumbItem: workPoint,
    );
    center = TabCombine(
      iconMargin: EdgeInsets.zero,
      body: AImage.localImage("logo_not_bg", size: Size(36.w, 36.w)),
      tabView: const CenterPage(),
      breadCrumbItem: centerPoint,
    );
    work = TabCombine(
      body: Text('仓库', style: text14),
      tabView: const ApplicationPage(),
      icon: AImage.localImage("warehouse", size: size),
      breadCrumbItem: warehousePoint,
    );
    my = TabCombine(
      body: Text('设置', style: text14),
      tabView: SetHomePage(),
      icon: AImage.localImage("setting", size: size),
      breadCrumbItem: settingPoint,
    );

    tabs = <TabCombine>[message, relation, center, work, my];
    tabIndex = tabs.indexOf(center).obs;
    tabController = TabController(
      length: tabs.length,
      vsync: this,
      initialIndex: tabIndex.value,
    );
    breadCrumbController.redirect(centerPoint);
    int preIndex = tabController.index;
    tabController.addListener(() {
      if (preIndex == tabController.index) {
        return;
      }
      tabIndex.value = tabController.index;
      breadCrumbController.redirect(tabs[tabIndex.value].breadCrumbItem!);
      preIndex = tabController.index;
    });
  }

  Widget _buildTabTick(Widget icon, String label) {
    return Obx(() => SizedBox(
          width: 200.w,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Tab(
                  iconMargin: const EdgeInsets.all(4),
                  icon: icon,
                  child: Text(label, style: text14),
                ),
              ),
              Positioned(
                right: 0,
                child: messageCtrl.hasNoRead()
                    ? Icon(Icons.circle, color: Colors.redAccent, size: 10.w)
                    : Container(),
              ),
            ],
          ),
        ));
  }
}
