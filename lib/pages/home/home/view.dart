import 'package:extended_tabs/extended_tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/controller/index.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/main.dart';
import 'package:orginone/util/toast_utils.dart';
import 'package:orginone/widget/badge_widget.dart';
import 'package:orginone/widget/gy_scaffold.dart';
import 'package:orginone/widget/unified.dart';

import 'logic.dart';
import 'state.dart';

class HomePage extends BaseGetView<HomeController, HomeState> {
  const HomePage({super.key});

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
          toolbarHeight: 0,
          body: Column(
            children: [
              Container(
                height: 300,
                width: 300,
                color: Colors.red,
              ),
              //TODO:暂时注 用到细调
              // const UserBar(),
              // Expanded(
              //   child: ExtendedTabBarView(
              //     shouldIgnorePointerWhenScrolling: false,
              //     controller: state.tabController,
              //     children: [
              //       KeepAliveWidget(child: MessageChats()),
              //       KeepAliveWidget(child: WorkPage()),
              //       KeepAliveWidget(child: IndexPage()),
              //       KeepAliveWidget(child: StorePage()),
              //       KeepAliveWidget(child: SettingPage()),
              //     ],
              //   ),
              // ),
              // bottomButton(),
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
          ExtendedTab(
              child: button(
                  homeEnum: HomeEnum.chat, path: 'chat', unPath: 'unchat')),
          ExtendedTab(
              child: button(
                  homeEnum: HomeEnum.work, path: 'work', unPath: 'unwork')),
          ExtendedTab(
              child: button(
                  homeEnum: HomeEnum.door, path: 'home', unPath: 'unhome')),
          ExtendedTab(
              child: button(
                  homeEnum: HomeEnum.store, path: 'store', unPath: 'unstore')),
          ExtendedTab(
            child: button(
                homeEnum: HomeEnum.setting,
                path: 'setting',
                unPath: 'unsetting'),
          ),
        ],
        controller: state.tabController,
        onTap: (index) {
          controller.jumpTab(HomeEnum.values[index]);
        },
        indicator: const BoxDecoration(),
      ),
    );
  }

  Widget button({
    required HomeEnum homeEnum,
    required String path,
    required String unPath,
  }) {
    return Obx(() {
      var isSelected = settingCtrl.homeEnum.value == homeEnum;
      var mgsCount = 0;
      if (homeEnum == HomeEnum.work) {
        mgsCount = settingCtrl.provider.work?.todos.length ?? 0;
      } else if (homeEnum == HomeEnum.chat) {
        var chats = settingCtrl.chats;
        for (var element in chats) {
          mgsCount += element.chatdata.noReadCount;
        }
      }
      return BadgeTabWidget(
        imgPath: !isSelected ? unPath : path,
        body: Text(homeEnum.label,
            style: isSelected ? selectedStyle : unSelectedStyle),
        mgsCount: mgsCount,
      );
    });
  }

  TextStyle get unSelectedStyle =>
      TextStyle(color: XColors.black3, fontSize: 16.sp);

  TextStyle get selectedStyle =>
      TextStyle(color: XColors.selectedColor, fontSize: 16.sp);
}
