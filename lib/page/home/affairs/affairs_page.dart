import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/component/unified_colors.dart';

import 'affairs_page_controller.dart';

class AffairsPage extends StatefulWidget {
  const AffairsPage({Key? key}) : super(key: key);

  @override
  State<AffairsPage> createState() => _AffairsPageState();
}

class _AffairsPageState extends State<AffairsPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const AffairsTab();
  }

  @override
  bool get wantKeepAlive => true;
}

class AffairsTab extends GetView<AffairsPageController> {
  const AffairsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _tabBar(),
        _line(),
        _content(),
      ],
    );
  }

  Widget _tabBar() {
    return GetBuilder<AffairsPageController>(
        init: controller,
        builder: (controller) {
          return Container(
            color: UnifiedColors.white,
            child: TabBar(
              isScrollable: false,
              controller: controller.tabController,
              labelColor: UnifiedColors.themeColor,
              unselectedLabelColor: UnifiedColors.black6,
              indicatorColor: UnifiedColors.themeColor,
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: TextStyle(fontSize: 20.sp),
              tabs: controller.tabs.map((item) => item.body!).toList(),
            ),
          );
        });
  }

  Widget _tabBarItem(String title, {bool showRightImage = true}) {
    return Tab(
        child: Container(
      color: Colors.yellow,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            color: Colors.red,
            child: Center(
              child: Text(title),
            ),
          ),

          ///分割符自定义，可以放任何widget
          showRightImage
              ? Container(
                  width: 1.w,
                  height: 30.h,
                  color: UnifiedColors.lineLight2,
                )
              : Container(
                  width: 1.w, height: 30.h, color: UnifiedColors.transparent)
        ],
      ),
    ));
  }

  _content() {
    return Expanded(
      flex: 1,
      child: TabBarView(
        controller: controller.tabController,
        children: controller.tabs.map((item) => item.tabView).toList(),
      ),
    );
  }

  _line() {
    return Divider(
      height: 1.h,
      color: UnifiedColors.lineLight,
    );
  }
}
