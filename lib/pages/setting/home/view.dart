import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/dart/core/getx/base_get_page_view.dart';
import 'package:orginone/pages/setting/cofig.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/keep_alive_widget.dart';

import 'logic.dart';
import 'relation/view.dart';
import 'standard/view.dart';
import 'state.dart';

class SettingCenterPage
    extends BaseGetPageView<SettingCenterController, SettingCenterState> {
  @override
  Widget buildView() {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            tabBar(),
            Expanded(
              child: TabBarView(
                controller: state.tabController,
                children: [
                  KeepAliveWidget(child: RelationPage()),
                  KeepAliveWidget(child: StandardPage()),
                ],
              ),
            )
          ],
        ));
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
  SettingCenterController getController() {
    return SettingCenterController();
  }

  @override
  String tag() {
    // TODO: implement tag
    return 'SettingCenter';
  }
}
