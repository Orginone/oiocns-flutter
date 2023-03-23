import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/widget/gy_scaffold.dart';
import 'package:orginone/widget/keep_alive_widget.dart';

import 'have_initiated/view.dart';
import 'logic.dart';
import 'start/view.dart';
import 'state.dart';


class WorkStartPage extends BaseGetView<WorkStartController,WorkStartState>{
  @override
  Widget buildView() {
    return GyScaffold(
      titleName: "事项",
      body: Column(
        children: [
          tabBar(),
          Expanded(
            child: TabBarView(
              controller: state.tabController,
              children: [
                KeepAliveWidget(child: StartPage(state.species)),
                KeepAliveWidget(child: HaveInitiatedPage(state.species)),
              ],
            ),
          )
        ],
      ),
    );
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
            height: 70.h,
          );
        }).toList(),
        indicatorColor: XColors.themeColor,
        indicatorSize: TabBarIndicatorSize.label,
        unselectedLabelColor: Colors.grey,
        unselectedLabelStyle: TextStyle(fontSize: 23.sp),
        labelColor: XColors.themeColor,
        labelStyle: TextStyle(fontSize: 26.sp),
        isScrollable: true,
      ),
    );
  }
}