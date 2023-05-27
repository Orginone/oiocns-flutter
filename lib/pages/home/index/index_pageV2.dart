import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/pages/home/index/index_page.dart';
import 'package:orginone/widget/unified.dart';

import 'news/news_page.dart';
import 'state.dart';
import 'widgets/IndexTodoTabBar.dart';
import 'widgets/dataMonitoring.dart';

class IndexTabPage extends StatefulWidget {
  const IndexTabPage({super.key});

  @override
  State<StatefulWidget> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexTabPage>
    with SingleTickerProviderStateMixin {
  late TabController tabCtrl;

  @override
  void initState() {
    super.initState();
    tabCtrl = TabController(length: 6, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    var children = [
      IndexPage(),
      // IndexTodoTabBarWidget(),
      // DataMonitoring(),
      // IndexNewsPage(),
      // DataMonitoring(),
      // IndexNewsPage(),
    ];
    return Column(
      children: [
        // tabBar(),
        Expanded(child: TabBarView(controller: tabCtrl, children: children))
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
        controller: tabCtrl,
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
}
