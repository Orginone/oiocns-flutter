import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/dart/core/getx/base_get_page_view.dart';
import 'package:orginone/pages/other/work/process_approval/view.dart';
import 'package:orginone/widget/keep_alive_widget.dart';

import '../widget.dart';
import 'logic.dart';
import 'state.dart';



class ToDoPage extends BaseGetPageView<ToDoController,ToDoState>{
  @override
  Widget buildView() {
    return Column(
      children: [
        nonIndicatorTabBar(state.tabController,WorkEnum.values.map((e) => e.label).toList()),
        Expanded(
          child: TabBarView(
            controller: state.tabController,
            children: WorkEnum.values.map((e) => KeepAliveWidget(child: ProcessApprovalPage(e),)).toList(),
          ),
        )
      ],
    );
  }

  @override
  ToDoController getController() {
    return ToDoController();
  }
  @override
  String tag() {
    // TODO: implement tag
    return "todo";
  }


}