import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:orginone/component/text_avatar.dart';
import 'package:orginone/component/unified_scaffold.dart';
import 'package:orginone/component/unified_text_style.dart';
import 'package:signalr_core/signalr_core.dart';

import '../../config/custom_colors.dart';
import '../../routers.dart';
import '../../util/hub_util.dart';
import 'home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  get _actions => [
        GFIconButton(
            color: CustomColors.lightGrey,
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              Get.toNamed(Routers.search);
            }),
        GFIconButton(
            color: CustomColors.lightGrey,
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed: () {}),
      ];

  get _leading => TextAvatar(
        avatarName: controller.user.userName,
        type: TextAvatarType.avatar,
        textStyle: text16White,
        margin: const EdgeInsets.all(10),
        status: Obx(() {
          Color color;
          switch (HubUtil().state!.value) {
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
      );

  get _title => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        GetBuilder<HomeController>(
            init: controller,
            builder: (controller) {
              return GestureDetector(
                  onTap: () {
                    Get.toNamed(Routers.spaceChoose);
                  },
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.repeat, color: Colors.black, size: 18),
                        Container(
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0)),
                        Expanded(
                          child: Text(
                            controller.currentSpace.name,
                            style: text16Bold,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ]));
            }),
      ]);

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
            ]),
        child: GFTabBar(
          tabBarHeight: 60,
          indicatorColor: Colors.blueAccent,
          tabBarColor: CustomColors.easyGrey,
          labelColor: Colors.black,
          labelStyle: const TextStyle(fontSize: 12),
          length: controller.tabController.length,
          controller: controller.tabController,
          tabs: controller.tabs.map((e) => e.tab).toList(),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return UnifiedScaffold(
      appBarActions: _actions,
      appBarTitle: _title,
      appBarLeading: _leading,
      body: _body,
      bottomNavigationBar: _bottomNavigatorBar,
    );
  }
}
