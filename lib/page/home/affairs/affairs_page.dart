import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/component/unified_colors.dart';
import 'package:orginone/page/home/affairs/task/task_list.dart';
import 'affairs_page_controller.dart';
import 'copy/copy_list.dart';
import 'instance/instance_list.dart';
import 'record/record_list.dart';

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
    return AffairsTab();
  }

  @override
  bool get wantKeepAlive => true;
}

class AffairsTab extends GetView<AffairsPageController> {
  AffairsTab({Key? key}) : super(key: key);

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
        children:  [
          AffairsTaskWidget(),
          AffairsRecordWidget(),
          AffairsInstanceWidget(),
          AffairsCopyWidget(),
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
