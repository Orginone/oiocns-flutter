import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:orginone/component/unified_colors.dart';
import 'package:orginone/page/home/affairs/affairs_controller.dart';

class AffairsPage extends GetView<AffairsController> {
  const AffairsPage({Key? key}) : super(key: key);

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
    return GetBuilder<AffairsController>(
        init: controller,
        builder: (controller) {
          return Container(
            color: UnifiedColors.white,
            child: GFTabBar(
              isScrollable: false,
              controller: controller.tabController,
              labelColor: UnifiedColors.themeColor,
              unselectedLabelColor: UnifiedColors.black6,
              indicatorColor: UnifiedColors.themeColor,
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: TextStyle(fontSize: 14.sp),
              tabs: const [
                Tab(text: '代办'),
                Tab(text: '已办'),
                Tab(text: '已完结'),
                Tab(text: '我的发起'),
              ], length: 4,
            ),
          );
        });
  }

  _content() {
    return Expanded(
      flex: 1,
      child: GFTabBarView(
        controller: controller.tabController,
        children: [
          Container(
            color: Colors.red,
          ),
          Container(
            color: Colors.black12,
          ),
          Container(
            color: Colors.pink,
          ),
          Container(
            color: Colors.red,
          ),
        ],
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
