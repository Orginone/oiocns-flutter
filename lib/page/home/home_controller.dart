import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/page/home/affairs/affairs_page.dart';
import 'package:orginone/page/home/center/center_page.dart';
import 'package:orginone/page/home/message/message_controller.dart';
import 'package:orginone/page/home/mine/mine_page.dart';
import 'package:orginone/page/home/organization/organization_controller.dart';
import 'package:orginone/page/home/organization/organization_page.dart';
import 'package:orginone/page/home/work/work_page.dart';
import 'package:orginone/util/any_store_util.dart';
import 'package:orginone/util/hub_util.dart';

import '../../api/company_api.dart';
import '../../api/person_api.dart';
import '../../api_resp/login_resp.dart';
import '../../api_resp/target_resp.dart';
import '../../api_resp/tree_node.dart';
import '../../api_resp/user_resp.dart';
import '../../util/hive_util.dart';
import 'message/message_page.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  Logger log = Logger("HomeController");

  MessageController messageController = Get.find<MessageController>();
  OrganizationController organizationController =
      Get.find<OrganizationController>();

  UserResp user = HiveUtil().getValue(Keys.user);

  late List<TabCombine> tabs;
  late TabController tabController;
  late BuildContext context;

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
    AnyStoreUtil().disconnect();
    HubUtil().disconnect();
    super.onClose();
  }

  Future<void> _initCurrentSpace() async {
    var userInfo = HiveUtil().getValue(Keys.userInfo);
    currentSpace = TargetResp.copyWith(userInfo);
    currentSpace.name = "个人空间";
  }

  void _initTabs() {
    var message = _buildTabTick(Icons.group_outlined, '沟通');
    var relation = _buildTab(Icons.book_outlined, '办事');
    var center = _buildCenter(Icons.circle);
    var work = _buildTab(Icons.warehouse_outlined, '仓库');
    var my = _buildTab(Icons.person, '设置');

    tabs = <TabCombine>[
      TabCombine(message, const MessagePage()),
      TabCombine(relation, const AffairsPage()),
      TabCombine(center, const CenterPage()),
      TabCombine(work, const WorkPage()),
      TabCombine(my, const MinePage()),
    ];

    tabController = TabController(length: tabs.length, vsync: this);
  }

  Tab _buildTab(IconData iconData, String label) {
    return Tab(
      iconMargin: EdgeInsets.all(5.w),
      icon: Icon(iconData),
      child: Text(label),
    );
  }

  Widget _buildTabTick(IconData iconData, String label) {
    return GetBuilder<MessageController>(
      builder: (controller) => Container(
        width: 100.w,
        child: Stack(
          children: [
            Tab(
              iconMargin: EdgeInsets.all(5.w),
              icon: Icon(iconData),
              child: Text(label),
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
    HiveUtil().putValue(Keys.user, loginResp.user);
    HiveUtil().accessToken = loginResp.accessToken;

    // 当前页面需要变化
    currentSpace = targetResp;
    await _loadTree();
    update();

    // 会话需要分组
    messageController.sortingGroups();
    messageController.update();

    // 组织架构页面需要变化
    organizationController.update();
  }

  _loadTree() async {
    TargetResp userInfo = HiveUtil().getValue(Keys.userInfo);
    if (userInfo.id != currentSpace.id) {
      nodeCombine = await CompanyApi.tree();
    } else {
      nodeCombine = null;
    }
  }
}

class TabCombine {
  final Widget _tab;
  final Widget _widget;

  const TabCombine(this._tab, this._widget);

  Widget get widget => _widget;

  Widget get tab => _tab;
}
