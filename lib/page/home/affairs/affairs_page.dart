import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:orginone/component/unified_colors.dart';
import 'package:orginone/page/home/affairs/affairs_controller.dart';
import 'package:orginone/page/home/affairs/affairs_list.dart';
import 'package:orginone/page/home/affairs/affairs_type_enum.dart';

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
            child: TabBar(
              isScrollable: false,
              controller: controller.tabController,
              labelColor: UnifiedColors.themeColor,
              unselectedLabelColor: UnifiedColors.black6,
              indicatorColor: UnifiedColors.themeColor,
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: TextStyle(fontSize: 14.sp),
              tabs: const [
                Tab(text: '待办'),
                Tab(text: '已办'),
                Tab(text: '我的发起'),
                Tab(text: '抄送我的'),
              ],
            ),
          );
        });
  }

  _content() {
    return Expanded(
      flex: 1,
      child: TabBarView(
        controller: controller.tabController,
        children: [
          AffairsList(AffairsTypeEnum.waiting),
          AffairsList(AffairsTypeEnum.finish),
          AffairsList(AffairsTypeEnum.mine),
          AffairsList(AffairsTypeEnum.copy),
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
