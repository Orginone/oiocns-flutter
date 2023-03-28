import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/dart/core/getx/base_get_page_view.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/pages/index/index_page.dart';

import '../../../dart/core/getx/base_controller.dart';

class FunctionPage extends BaseGetPageView<FunctionController, FunctionState> {
  @override
  Widget buildView() {
    return Column(
      children: [
        tabBar(),
        Expanded(
          child: TabBarView(
            controller: state.tabController,
            children: [
              IndexPage(),
              Container(),
              Container(),
              Container(),
              Container(),
            ],
          ),
        )
      ],
    );
  }

  @override
  FunctionController getController() {
    return FunctionController();
  }

  Widget tabBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
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
              unselectedLabelStyle: TextStyle(fontSize: 18.sp),
              labelColor: XColors.themeColor,
              labelStyle: TextStyle(fontSize: 21.sp),
              isScrollable: true,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.more_vert,
              )),
        ),
      ],
    );
  }

  @override
  String tag() {
    // TODO: implement tag
    return this.toString();
  }
}

class FunctionController extends BaseController<FunctionState>
    with GetTickerProviderStateMixin {
  final FunctionState state = FunctionState();
  FunctionController() {
    state.tabController = TabController(length: tabTitle.length, vsync: this);
  }
}

class FunctionState extends BaseGetState {
  late TabController tabController;
}

const List<String> tabTitle = [
  "工作台",
  "看板",
  "新闻",
  "共享",
  "交易"
];