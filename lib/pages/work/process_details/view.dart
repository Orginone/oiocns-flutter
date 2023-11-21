import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/config/unified.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/components/widgets/gy_scaffold.dart';
import 'logic.dart';
import 'process_info/view.dart';
import 'state.dart';
import 'use_traces/view.dart';

///办事 详情
class ProcessDetailsPage
    extends BaseGetView<ProcessDetailsController, ProcessDetailsState> {
  const ProcessDetailsPage({super.key});

  @override
  Widget buildView() {
    return GyScaffold(
        titleName: state.todo?.taskdata.title, body: _buildMainView());
  }

  _buildMainView() {
    if (state.todo?.instance != null) {
      //返回流程视图
      return _buildInstanceView();
    }
    return _buildApplyView();
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
        unselectedLabelStyle: TextStyle(fontSize: 22.sp),
        labelColor: XColors.themeColor,
        labelStyle: TextStyle(fontSize: 24.sp),
        isScrollable: true,
      ),
    );
  }

  _buildInstanceView() {
    return Column(
      children: [
        tabBar(),
        Expanded(
          child: TabBarView(
            controller: state.tabController,
            children: [
              ProcessInfoPage(),
              UseTracesPage(),
            ],
          ),
        )
      ],
    );
  }

  _buildApplyView() {
    return const Center(child: Text('申请视图'));
  }
}
