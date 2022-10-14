import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/page/home/message/message_controller.dart';
import 'package:orginone/page/home/mine/mine_page.dart';
import 'package:orginone/page/home/organization/organization_controller.dart';
import 'package:orginone/page/home/organization/organization_page.dart';
import 'package:orginone/page/home/work/work_page.dart';
import 'package:orginone/util/any_store_util.dart';
import 'package:orginone/util/hub_util.dart';

import '../../api/person_api.dart';
import '../../api_resp/login_resp.dart';
import '../../api_resp/target_resp.dart';
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
  TargetResp userInfo = HiveUtil().getValue(Keys.userInfo);

  late List<TabCombine> tabs;
  late TabController tabController;
  late BuildContext context;

  late TargetResp currentSpace;

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
    currentSpace = TargetResp.copyWith(userInfo);
    currentSpace.name = "个人空间";
  }

  void _initTabs() {
    var message = _buildTab(Icons.chat_bubble_outline, '消息');
    var relation = _buildTab(Icons.groups_outlined, '关系');
    var work = _buildTab(Icons.work_outline, '工作台');
    var my = _buildTab(Icons.person_outline, '我的');

    tabs = <TabCombine>[
      TabCombine(message, const MessagePage()),
      TabCombine(relation, const OrganizationPage()),
      TabCombine(work, const WorkPage()),
      TabCombine(my, const MinePage()),
    ];

    tabController = TabController(length: tabs.length, vsync: this);
  }

  Tab _buildTab(IconData iconData, String label) {
    return Tab(
        iconMargin: const EdgeInsets.all(5),
        icon: Icon(iconData),
        child: Text(label));
  }

  void switchSpaces(TargetResp targetResp) async {
    LoginResp loginResp = await PersonApi.changeWorkspace(targetResp.id);
    HiveUtil().putValue(Keys.user, loginResp.user);
    HiveUtil().accessToken = loginResp.accessToken;

    // 当前页面需要变化
    currentSpace = targetResp;
    update();

    // 会话需要分组
    messageController.sortingGroups();
    messageController.update();

    // 组织架构页面需要变化
    organizationController.update();
  }
}

class TabCombine {
  final Tab _tab;
  final Widget _widget;

  const TabCombine(this._tab, this._widget);

  Widget get widget => _widget;

  Tab get tab => _tab;
}
