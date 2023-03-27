


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/components/unified.dart';

Widget nonIndicatorTabBar(TabController tabController,List<String> tabTitle) {
  return Container(
    color: Colors.white,
    alignment: Alignment.centerLeft,
    child: TabBar(
      controller: tabController,
      tabs: tabTitle.map((e) {
        return Tab(
          text: e,
          height: 50.h,
        );
      }).toList(),
      unselectedLabelColor: Colors.grey,
      unselectedLabelStyle: TextStyle(fontSize: 21.sp),
      labelColor: XColors.themeColor,
      labelStyle: TextStyle(fontSize: 21.sp),
      isScrollable: true,
      indicator: const BoxDecoration(),
    ),
  );
}