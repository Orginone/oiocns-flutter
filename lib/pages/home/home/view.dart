import 'package:extended_tabs/extended_tabs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/components/index.dart';
import 'package:orginone/common/routers/pages.dart';
import 'package:orginone/dart/controller/index.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/main_base.dart';
import 'package:orginone/pages/chat/message_chats/message_chats_page.dart';
import 'package:orginone/pages/home/components/user_bar.dart';
import 'package:orginone/pages/home/portal/view.dart';
import 'package:orginone/pages/relation/index.dart';
import 'package:orginone/pages/store/view.dart';
import 'package:orginone/pages/work/view.dart';
import 'package:orginone/utils/toast_utils.dart';
import 'package:orginone/config/unified.dart';

import 'logic.dart';
import 'state.dart';

class HomePageOld extends BaseGetView<HomeController, HomeState> {
  dynamic data;
  HomePageOld({super.key, this.data});

  @override
  Widget buildView() {
    return WillPopScope(
      onWillPop: () async {
        if (state.lastCloseApp == null ||
            DateTime.now().difference(state.lastCloseApp!) >
                const Duration(seconds: 1)) {
          state.lastCloseApp = DateTime.now();
          ToastUtils.showMsg(msg: '再按一次退出');
          return false;
        }
        return true;
      },
      child: GyScaffold(
          backgroundColor: Colors.white,
          toolbarHeight: null == data ? 0 : null,
          body: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    if (null == data) UserBar(),
                    Expanded(
                      child: ExtendedTabBarView(
                        shouldIgnorePointerWhenScrolling: false,
                        controller: state.tabController,
                        children: const [
                          KeepAliveWidget(child: MessageChats()),
                          KeepAliveWidget(child: WorkPage()),
                          KeepAliveWidget(child: PortalPage()),
                          KeepAliveWidget(child: StorePage()),
                          KeepAliveWidget(child: RelationPage()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // InfoListPage(relationCtrl.relationModel),
              bottomButton(),
            ],
          )),
    );
  }

  Widget bottomButton() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade400, width: 0.4),
        ),
      ),
      child: TabBar(
        tabs: [
          ExtendedTab(child: button(homeEnum: HomeEnum.chat, path: 'chat')),
          ExtendedTab(child: button(homeEnum: HomeEnum.work, path: 'work')),
          ExtendedTab(child: button(homeEnum: HomeEnum.door, path: 'home')),
          ExtendedTab(child: button(homeEnum: HomeEnum.store, path: 'store')),
          ExtendedTab(
            child: button(homeEnum: HomeEnum.relation, path: 'relation'),
          ),
        ],
        controller: state.tabController,
        onTap: (index) {
          print(">>>>====ModelTabs.onTap");
          RoutePages.clearRoute();
          controller.jumpTab(HomeEnum.values[index]);
        },
        indicator: const BoxDecoration(),
      ),
    );
  }

  Widget button({
    required HomeEnum homeEnum,
    required String path,
  }) {
    return Obx(() {
      var isSelected = relationCtrl.homeEnum.value == homeEnum;
      var mgsCount = 0;
      if (homeEnum == HomeEnum.work) {
        mgsCount = relationCtrl.provider.work?.todos.length ?? 0;
      } else if (homeEnum == HomeEnum.chat) {
        mgsCount = relationCtrl.noReadMgsCount.value;
      }
      return BadgeTabWidget(
        imgPath: path,
        foreColor: isSelected ? XColors.selectedColor : XColors.doorDesGrey,
        body: Text(homeEnum.label),
        mgsCount: mgsCount,
      );
    });
  }
}
