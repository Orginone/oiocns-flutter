import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/component/bread_crumb.dart';
import 'package:orginone/component/unified_text_style.dart';
import 'package:orginone/config/bread_crumb_points.dart';
import 'package:orginone/page/home/affairs/affairs_page.dart';
import 'package:orginone/page/home/center/center_page.dart';
import 'package:orginone/page/home/message/contact/contact_page.dart';
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
import '../../logic/authority.dart';
import '../../util/hive_util.dart';
import 'message/message_page.dart';
import 'organization/friends/friends_page.dart';

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
    var message = _buildTabTick(Icons.group_outlined, '沟通');
    var relation = _buildTab(Icons.book_outlined, '办事');
    var center = _buildCenter(Icons.circle);
    var work = _buildTab(Icons.warehouse_outlined, '仓库');
    var my = _buildTab(Icons.person_outline, '设置');

    tabs = <TabCombine>[
      TabCombine(message, const MessagePage(), chatPoint),
      TabCombine(relation, const AffairsPage(), workPoint),
      TabCombine(center, const CenterPage(), centerPoint),
      TabCombine(work, const WorkPage(), warehousePoint),
      TabCombine(my, const MinePage(), settingPoint),
    ];

    tabController = TabController(length: tabs.length, vsync: this);
    tabController.addListener(() {
      if (tabController.index != tabController.animation?.value) {
        return;
      }

      var preTab = tabs[tabController.previousIndex];
      var tab = tabs[tabController.index];
      if (tab._tab == center) {
        titleStatus.value = TitleStatus.home;
        breadCrumbController.clear();
      } else {
        titleStatus.value = TitleStatus.breadCrumb;
        breadCrumbController.pops(preTab.breadCrumbItem.id);
        breadCrumbController.push(tab.breadCrumbItem);
      }
    });
  }

  Tab _buildTab(IconData iconData, String label) {
    return Tab(
      iconMargin: EdgeInsets.all(5.w),
      icon: Icon(iconData),
      child: Text(label, style: text14),
    );
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

  Tab _buildCenter(IconData iconData) {
    double width = 36.w;
    return Tab(
      iconMargin: EdgeInsets.zero,
      icon: Container(
        width: width,
        height: width,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(width)),
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

class TabCombine {
  final Widget _tab;
  final Widget _widget;
  final Item<String> _breadCrumbItem;

  const TabCombine(this._tab, this._widget, this._breadCrumbItem);

  Widget get widget => _widget;

  Widget get tab => _tab;

  Item<String> get breadCrumbItem => _breadCrumbItem;
}
