import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:orginone/widget/unified.dart';
import 'package:orginone/dart/core/getx/base_get_page_view.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/images.dart';
import 'package:orginone/pages/index/index_page.dart';
import 'package:orginone/pages/index/news/news_page.dart';
import 'package:orginone/pages/index/widgets/IndexTodoTabBar.dart';
import 'package:orginone/pages/index/widgets/dataMonitoring.dart';
import 'package:orginone/widget/keep_alive_widget.dart';

import '../../../dart/core/getx/base_controller.dart';
import '../../../dart/core/getx/base_get_view.dart';

class IndexTabPageok
    extends BaseGetPageView<FunctionController, FunctionState> {
  @override
  Widget buildView() {
    return Column(
      children: [
        tabBar(),
        Expanded(
          child: TabBarView(
            controller: state.tabController,
            children: [
              KeepAliveWidget(child: IndexPage()),
              KeepAliveWidget(child: IndexTodoTabBarWidget()),
              KeepAliveWidget(child: DataMonitoring()),
              KeepAliveWidget(child: IndexNewsPage()),
              KeepAliveWidget(child: DataMonitoring()),
              KeepAliveWidget(child: IndexNewsPage()),
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
          onTap: () {Get.snackbar("奥集能", "欢迎！欢迎！热烈欢迎");},
          child: const Padding(
              padding: EdgeInsets.all(8.0),
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

// TODO 单位管理员显示控制台
const List<String> tabTitle = ["首页", "工作台", "看板", "新闻", "共享", "交易"];
