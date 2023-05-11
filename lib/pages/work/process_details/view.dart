import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/widget/unified.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/widget/gy_scaffold.dart';
import 'logic.dart';
import 'process_info/view.dart';
import 'state.dart';
import 'use_traces/view.dart';

class ProcessDetailsPage
    extends BaseGetView<ProcessDetailsController, ProcessDetailsState> {
  @override
  Widget buildView() {
    return GyScaffold(
      titleName: state.todo.title,
      body: Column(
        children: [
          tabBar(),
          Expanded(
            child: TabBarView(
              children: [
                ProcessInfoPage(),
                UseTracesPage(),
              ],
              controller: state.tabController,
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
            height: 60.h,
          );
        }).toList(),
        indicatorSize: TabBarIndicatorSize.label,
        indicatorColor: XColors.themeColor,
        unselectedLabelColor: Colors.grey,
        unselectedLabelStyle: TextStyle(fontSize: 21.sp),
        labelColor: XColors.themeColor,
        labelStyle: TextStyle(fontSize: 23.sp),
        isScrollable: true,
      ),
    );
  }
}
