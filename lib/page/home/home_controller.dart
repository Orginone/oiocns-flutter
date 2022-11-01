import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/component/bread_crumb.dart';
import 'package:orginone/component/unified_text_style.dart';
import 'package:orginone/config/bread_crumb_points.dart';
import 'package:orginone/page/home/affairs/affairs_page.dart';
import 'package:orginone/page/home/center/center_page.dart';
import 'package:orginone/page/home/home_page.dart';
import 'package:orginone/page/home/message/message_controller.dart';
import 'package:orginone/page/home/mine/mine_page.dart';
import 'package:orginone/page/home/organization/organization_controller.dart';
import 'package:orginone/page/home/work/work_page.dart';
import 'package:orginone/util/any_store_util.dart';
import 'package:orginone/util/hub_util.dart';

import '../../api/company_api.dart';
import '../../api/person_api.dart';
import '../../api_resp/login_resp.dart';
import '../../api_resp/target_resp.dart';
import '../../api_resp/tree_node.dart';
import '../../component/tab_combine.dart';
import '../../logic/authority.dart';
import '../../util/hive_util.dart';
import 'message/message_page.dart';

enum TitleStatus { home, breadCrumb }

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  Logger log = Logger("HomeController");

  var messageController = Get.find<MessageController>();
  var organizationCtrl = Get.find<OrganizationController>();

  /// 全局面包屑
  var breadCrumbController = BreadCrumbController<String>();
  var titleStatus = TitleStatus.home.obs;

  /// Tab 控制器
  late List<TabCombine> tabs;
  late TabController tabController;

  /// 当前空间
  late TargetResp currentSpace;
  NodeCombine? nodeCombine;

  @override
  void onInit() {
    super.onInit();
    _initTabs();
    _initCurrentSpace();
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
    AnyStoreUtil().disconnect();
    HubUtil().disconnect();
    breadCrumbController.dispose();
    tabController.dispose();
  }

  Future<void> _initCurrentSpace() async {
    var userInfo = auth.userInfo;
    currentSpace = TargetResp.copyWith(userInfo);
    currentSpace.name = "个人空间";
  }

  void _initTabs() {
    var message = TabCombine(
      body: Text('沟通', style: text14),
      tabView: const MessagePage(),
      icon: Icons.group_outlined,
      breadCrumbItem: chatPoint,
    );
    var relation = TabCombine(
      body: Text('办事', style: text14),
      tabView: const AffairsPage(),
      icon: Icons.book_outlined,
      breadCrumbItem: workPoint,
    );
    var center = const TabCombine(
      // icon: Icons.circle,
      tabView: HomePage(),
    );
    var work = TabCombine(
      body: Text('仓库', style: text14),
      tabView: const WorkPage(),
      icon: Icons.warehouse_outlined,
      breadCrumbItem: warehousePoint,
    );
    var my = TabCombine(
      body: Text('设置', style: text14),
      tabView: const MinePage(),
      icon: Icons.person_outline,
      breadCrumbItem: settingPoint,
    );

    tabs = <TabCombine>[message, relation, center, work, my];

    tabController = TabController(length: tabs.length, vsync: this);
    tabController.addListener(() {
      if (tabController.index != tabController.animation?.value) {
        return;
      }

      var preTabCombine = tabs[tabController.previousIndex];
      var tabCombine = tabs[tabController.index];
      if (tabCombine == center) {
        titleStatus.value = TitleStatus.home;
        breadCrumbController.clear();
      } else {
        titleStatus.value = TitleStatus.breadCrumb;
        if (preTabCombine.breadCrumbItem != null) {
          breadCrumbController.pops(preTabCombine.breadCrumbItem!.id);
        }
        if (tabCombine.breadCrumbItem != null) {
          breadCrumbController.push(tabCombine.breadCrumbItem!);
        }
      }
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
    currentSpace = targetResp;
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
