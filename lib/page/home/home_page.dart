import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:orginone/component/text_avatar.dart';
import 'package:orginone/component/unified_scaffold.dart';
import 'package:orginone/component/unified_text_style.dart';
import 'package:orginone/util/any_store_util.dart';
import 'package:orginone/util/sys_util.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:signalr_core/signalr_core.dart';

import '../../component/unified_colors.dart';
import '../../component/unified_edge_insets.dart';
import '../../routers.dart';
import '../../util/hub_util.dart';
import '../../util/string_util.dart';
import 'home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    initPermission(context);

    SysUtil.setStatusBarBright();
    controller.context = context;
    return UnifiedScaffold(
      appBarActions: _actions(context),
      appBarTitle: _title,
      appBarLeading: _leading,
      body: _body,
      bottomNavigationBar: _bottomNavigatorBar,
    );
  }

  initPermission(BuildContext context) async {
    await [Permission.storage, Permission.notification].request();
  }

  Widget _popMenuItem(
    BuildContext context,
    IconData icon,
    String text,
    Function func,
  ) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.pop(context);
        func();
      },
      child: SizedBox(
        height: 40.h,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.black),
            Container(
              margin: EdgeInsets.only(left: 20.w),
            ),
            Text(text),
          ],
        ),
      ),
    );
  }

  Widget _popMenu(BuildContext context) {
    return PopupMenuButton(
      splashRadius: 10.w,
      padding: lr10,
      position: PopupMenuPosition.under,
      color: UnifiedColors.lightGrey,
      icon: const Icon(Icons.add, color: Colors.black, size: GFSize.MEDIUM),
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            child: _popMenuItem(
              context,
              Icons.qr_code_scanner,
              "扫一扫",
              () async {
                Get.toNamed(Routers.scanning);
              },
            ),
          ),
          PopupMenuItem(
            child: _popMenuItem(
              context,
              Icons.group_add_outlined,
              "创建群组",
              () {},
            ),
          ),
          PopupMenuItem(
            child: _popMenuItem(
              context,
              Icons.groups_outlined,
              "创建单位",
              () {},
            ),
          ),
        ];
      },
    );
  }

  List<Widget> _actions(BuildContext context) {
    return [
      GFIconButton(
          color: UnifiedColors.lightGrey,
          icon: const Icon(Icons.search, color: Colors.black),
          onPressed: () {
            Get.toNamed(Routers.search);
          }),
      _popMenu(context)
    ];
  }

  get _leading => TextAvatar(
        avatarName: StringUtil.getAvatarName(
          avatarName: controller.user.userName,
          type: TextAvatarType.avatar,
        ),
        textStyle: text16White,
        margin: all10,
      );

  get _title => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              Row(
                children: [
                  Obx(() {
                    Color color;
                    switch (HubUtil().state.value) {
                      case HubConnectionState.connecting:
                      case HubConnectionState.disconnecting:
                      case HubConnectionState.reconnecting:
                        color = Colors.yellow;
                        break;
                      case HubConnectionState.connected:
                        color = Colors.greenAccent;
                        break;
                      default:
                        color = Colors.redAccent;
                    }
                    return Icon(
                      Icons.circle,
                      size: 10,
                      color: color,
                    );
                  }),
                  Container(margin: EdgeInsets.only(left: 5.w)),
                  Text("会话", style: text10Bold),
                ],
              ),
              Container(margin: EdgeInsets.only(top: 5.h)),
              Row(
                children: [
                  Obx(() {
                    Color color;
                    switch (AnyStoreUtil().state.value) {
                      case HubConnectionState.connecting:
                      case HubConnectionState.disconnecting:
                      case HubConnectionState.reconnecting:
                        color = Colors.yellow;
                        break;
                      case HubConnectionState.connected:
                        color = Colors.greenAccent;
                        break;
                      default:
                        color = Colors.redAccent;
                    }
                    return Icon(
                      Icons.circle,
                      size: 10,
                      color: color,
                    );
                  }),
                  Container(margin: EdgeInsets.only(left: 5.w)),
                  Text("存储", style: text10Bold),
                ],
              )
            ],
          ),
          Container(padding: EdgeInsets.only(left: 10.w)),
          Icon(Icons.repeat, color: Colors.black, size: 18.w),
          Container(padding: EdgeInsets.only(left: 10.w)),
          Expanded(
            child: GetBuilder<HomeController>(
              init: controller,
              builder: (controller) {
                return GestureDetector(
                  onTap: () {
                    Get.toNamed(Routers.spaceChoose);
                  },
                  child: Text(
                    controller.currentSpace.name,
                    style: text16Bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              },
            ),
          ),
        ],
      );

  get _body => GFTabBarView(
      controller: controller.tabController,
      children: controller.tabs.map((e) => e.widget).toList());

  get _bottomNavigatorBar => Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(width: 0.5, color: Colors.black12)),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFE8E8E8),
              offset: Offset(8, 8),
              blurRadius: 10,
              spreadRadius: 1,
            )
          ],
        ),
        child: GFTabBar(
          tabBarHeight: 60,
          indicatorColor: Colors.blueAccent,
          tabBarColor: UnifiedColors.easyGrey,
          labelColor: Colors.black,
          labelStyle: const TextStyle(fontSize: 12),
          length: controller.tabController.length,
          controller: controller.tabController,
          tabs: controller.tabs.map((e) => e.tab).toList(),
        ),
      );
}
