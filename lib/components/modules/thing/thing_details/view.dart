import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/components/modules/thing/thing_details/state.dart';
import 'package:orginone/config/unified.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/components/widgets/gy_scaffold.dart';
import 'package:orginone/components/widgets/keep_alive_widget.dart';

import 'logic.dart';
import 'thing_info/view.dart';
import 'use_traces/view.dart';

class ThingDetailsPage
    extends BaseGetView<ThingDetailsController, ThingDetailsState> {
  const ThingDetailsPage({super.key});

  @override
  Widget buildView() {
    return GyScaffold(
        titleName: "资产详情",
        body: Column(
          children: [
            tabBar(),
            Expanded(
                child: TabBarView(
              controller: state.tabController,
              children: [
                KeepAliveWidget(child: ThingInfoPage()),
                KeepAliveWidget(child: UseTracesPage()),
              ],
            ))
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
