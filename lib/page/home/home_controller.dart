import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_treeview/flutter_treeview.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/api/company_api.dart';
import 'package:orginone/api/person_api.dart';
import 'package:orginone/api/store_server.dart';
import 'package:orginone/api_resp/login_resp.dart';
import 'package:orginone/api_resp/target_resp.dart';
import 'package:orginone/api_resp/tree_node.dart';
import 'package:orginone/component/bread_crumb.dart';
import 'package:orginone/component/tab_combine.dart';
import 'package:orginone/component/unified_text_style.dart';
import 'package:orginone/logic/authority.dart';
import 'package:orginone/api/chat_server.dart';
import 'package:orginone/page/home/affairs/affairs_page.dart';
import 'package:orginone/page/home/application/page/application_page.dart';
import 'package:orginone/page/home/center/center_page.dart';
import 'package:orginone/page/home/message/message_controller.dart';
import 'package:orginone/page/home/mine/set_home/set_home_page.dart';
import 'package:orginone/page/home/organization/organization_controller.dart';
import 'package:orginone/util/hive_util.dart';
import 'package:flutter_treeview/flutter_treeview.dart' as tree_view;

import 'message/message_page.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  Logger log = Logger("HomeController");

  var messageController = Get.find<MessageController>();
  var organizationCtrl = Get.find<OrganizationController>();

  /// 全局面包屑
  var breadCrumbController = BreadCrumbController<String>(topNode: topPoint);

  /// Tab 控制器
  late List<TabCombine> tabs;
  late TabController tabController;
  late HomeController homeController;
  late RxInt tabIndex;
  late TabCombine message, relation, center, work, my;

  /// 当前空间
  NodeCombine? nodeCombine;

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

  // @override
  // void onReady() {
  //   super.onReady();
  //   // 弹出更新框
  //   showDialog(
  //     context: context,
  //     barrierColor: null,
  //     builder: (context) => UpdaterDialog("1.修复聊天同步会话问题；\n2.修改重连时间为两秒；\n3.修改样式问题；\n3.修改样式问题；\n3.修改样式问题；\n3.修改样式问题；\n3.修改样式问题；\n3.修改样式问题；\n3.修改样式问题；\n3.修改样式问题；\n3.修改样式问题；\n3.修改样式问题；\n3.修改样式问题；"),
  //   );
  // }

  @override
  void onClose() {
    super.onClose();
    chatServer.stop();
    storeServer.stop();
    breadCrumbController.dispose();
    tabController.dispose();
  }

  void _initTabs() {
    message = TabCombine(
      customTab: _buildTabTick(Icons.group_outlined, "沟通"),
      tabView: const MessagePage(),
      breadCrumbItem: chatPoint,
    );
    relation = TabCombine(
      body: Text('办事', style: text14),
      tabView: const AffairsPage(),
      icon: Icons.book_outlined,
      breadCrumbItem: workPoint,
    );
    center = TabCombine(
      icon: Icons.circle,
      tabView: const CenterPage(),
      breadCrumbItem: centerPoint,
    );
    work = TabCombine(
      body: Text('仓库', style: text14),
      tabView: const ApplicationPage(),
      icon: Icons.warehouse_outlined,
      breadCrumbItem: warehousePoint,
    );
    my = TabCombine(
      body: Text('设置', style: text14),
      tabView: SetHomePage(),
      icon: Icons.person_outline,
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

  Widget _buildTabTick(IconData iconData, String label) {
    return GetBuilder<MessageController>(
      builder: (controller) => SizedBox(
        width: 100.w,
        child: Stack(
          children: [
            Tab(
              iconMargin: EdgeInsets.all(5.w),
              icon: Icon(iconData),
              child: Text(label, style: text14),
            ),
            Positioned(
              right: 0,
              child: controller.hasNoRead()
                  ? Icon(Icons.circle, color: Colors.redAccent, size: 10.w)
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }

  void switchSpaces(TargetResp targetResp) async {
    LoginResp loginResp = await PersonApi.changeWorkspace(targetResp.id);
    HiveUtil().accessToken = loginResp.accessToken;

    await loadAuth();

    // 当前页面需要变化
    await _loadTree();
    update();

    // 会话需要分组
    messageController.sortingGroups();
    messageController.update();

    // 组织架构页面需要变化
    organizationCtrl.update();
  }

  _loadTree() async {
    if (auth.isCompanySpace()) {
      nodeCombine = await CompanyApi.tree();
    } else {
      nodeCombine = null;
    }
  }
}
