import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/dart/core/getx/base_get_page_view.dart';
import 'package:orginone/pages/todo/workbench_page.dart';
import 'package:orginone/widget/keep_alive_widget.dart';

import 'logic.dart';
import 'process_approval/view.dart';
import 'state.dart';

class WorkPage extends BaseGetPageView<WorkController, WorkState> {
  @override
  Widget buildView() {
    return Container(
      color: Colors.grey.shade50,
      child: Column(
        children: [
          tabBar(),
          Expanded(
            child: TabBarView(
              controller: state.tabController,
              children: [
                KeepAliveWidget(child: ProcessApprovalPage(WorkEnum.todo)),
                KeepAliveWidget(child: ProcessApprovalPage(WorkEnum.done)),
                KeepAliveWidget(child: ProcessApprovalPage(WorkEnum.copy)),
                KeepAliveWidget(child: WorkbenchPage()),
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
            height: 40.h,
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

  @override
  WorkController getController() {
    return WorkController();
  }

  @override
  String tag() {
    // TODO: implement tag
    return this.toString();
  }
}
