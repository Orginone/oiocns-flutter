import 'package:extended_tabs/extended_tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/dart/core/getx/base_get_page_view.dart';
import 'package:orginone/config/unified.dart';

import 'digital_assets/digital_assets.dart';
import 'friend_dynamic/friend_dynamic.dart';
import 'group_dynamics/group_dynamics.dart';
import 'logic.dart';
import 'shared_software/shared_software.dart';
import 'state.dart';
import 'warehouse/warehouse.dart';
import 'welfare/welfare.dart';

class IndexPage extends BaseGetPageView<IndexController, IndexState> {
  IndexPage({super.key});

  @override
  Widget buildView() {
    return Column(
      children: [
        tabBar(),
        Expanded(
          child: ExtendedTabBarView(
              controller: state.tabController,
              children: const [
                GroupDynamics(),
                FriendDynamic(),
                SharedSoftware(),
                Warehouse(),
                Welfare(),
                DigitalAssets(),
              ]),
        )
      ],
    );
  }

  Widget tabBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            color: Colors.white,
            alignment: Alignment.centerLeft,
            child: ExtendedTabBar(
              controller: state.tabController,
              tabs: tabTitle.map((e) {
                return ExtendedTab(
                  scrollDirection: Axis.horizontal,
                  text: e,
                  height: 40.h,
                );
              }).toList(),
              indicatorColor: XColors.themeColor,
              indicatorSize: TabBarIndicatorSize.label,
              unselectedLabelColor: Colors.grey,
              unselectedLabelStyle: TextStyle(fontSize: 20.sp),
              labelColor: XColors.themeColor,
              labelStyle: TextStyle(fontSize: 22.sp),
              isScrollable: true,
              labelPadding: EdgeInsets.symmetric(horizontal: 10.w),
            ),
          ),
        ),
        IconButton(
          onPressed: () {},
          alignment: Alignment.center,
          icon: const Icon(
            Icons.menu,
          ),
          iconSize: 24.w,
          padding: EdgeInsets.zero,
        )
      ],
    );
  }

  @override
  IndexController getController() {
    return IndexController();
  }

  @override
  String tag() {
    // TODO: implement tag
    return 'index';
  }
}
