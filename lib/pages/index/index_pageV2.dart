import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/config/color.dart';
import 'package:orginone/dart/core/getx/base_get_page_view.dart';
import 'package:orginone/pages/index/index_page.dart';
import 'package:orginone/pages/index/news/news_page.dart';
import 'package:orginone/pages/index/news/searchBar.dart';
import 'package:orginone/pages/index/news/searchBarWidget.dart';
import 'package:orginone/pages/index/widgets/IndexTodoTabBar.dart';
import 'package:orginone/pages/index/widgets/dataMonitoring.dart';
import 'package:orginone/pages/todo/workbench_page.dart';
import 'package:orginone/widget/keep_alive_widget.dart';

// import 'initiate/view.dart';
import 'logic.dart';
// import 'process_approval/view.dart';
import 'state.dart';
// import 'to_do/view.dart';

class IndexTabPage extends BaseGetPageView<IndexController, IndexState> {
  @override
  Widget buildView() {
    return Column(
      children: [
        tabBar(),
        Expanded(
          child: TabBarView(
            controller: state.indextabController,
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

  Widget tabBar() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(color: Colors.grey.shade200, width: 1))),
      alignment: Alignment.centerLeft,
      child: TabBar(
        isScrollable: true,
        controller: state.indextabController,
        tabs: indexTabTitle.map((e) {
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
  IndexController getController() {
    return IndexController();
  }

  @override
  String tag() {
    // TODO: implement tag
    return this.toString();
  }
}
