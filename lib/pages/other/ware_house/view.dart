import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/dart/core/getx/base_get_page_view.dart';
import 'package:orginone/widget/keep_alive_widget.dart';

import 'logic.dart';
import 'state.dart';
import 'store/view.dart';
import 'ware_house_management/view.dart';

class WareHousePage
    extends BaseGetPageView<WareHouseController, WareHouseState> {
  @override
  Widget buildView() {
    return Column(
      children: [
        tabBar(),
        Expanded(
          child: TabBarView(
            controller: state.tabController,
            children: [
              KeepAliveWidget(child: WareHouseManagementPage()),
              KeepAliveWidget(child: StorePage()),
            ],
          ),
        )
      ],
    );
  }

  @override
  WareHouseController getController() {
    return WareHouseController();
  }

  Widget tabBar() {
    return Container(
      color: Colors.white,
      alignment: Alignment.centerLeft,
      child: TabBar(
        controller: state.tabController,
        tabs: tabTitle.map((e) {
          return Tab(
            text: e,
            height: 60.h,
          );
        }).toList(),
        indicatorColor: XColors.themeColor,
        unselectedLabelColor: Colors.grey,
        unselectedLabelStyle: TextStyle(fontSize: 21.sp),
        labelColor: XColors.themeColor,
        labelStyle: TextStyle(fontSize: 23.sp),
      ),
    );
  }

  @override
  String tag() {
    // TODO: implement tag
    return "WareHouse";
  }
}
