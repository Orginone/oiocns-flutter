import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/components/widgets/TargetActivity/activity_message.dart';
import 'package:orginone/dart/core/chat/activity.dart';
import 'package:orginone/dart/core/getx/base_get_list_page_view.dart';

import 'controller.dart';
import 'state.dart';

class CohortActivityPage
    extends BaseGetListPageView<CohortActivityController, CohortActivityState> {
  late String type;
  late String label;
  late GroupActivity cohortActivity;

  CohortActivityPage(this.type, this.label, this.cohortActivity, {super.key});

  @override
  Widget buildView() {
    return ListView(
        padding: EdgeInsets.symmetric(vertical: 15.h),
        children: GroupActivityItem(activity: controller.cohortActivity));
  }

  //渲染动态列表
  List<Widget> GroupActivityItem({required GroupActivity activity}) {
    return activity.activitys
        .where((item) => item.activityList.isNotEmpty)
        .map((item) {
      return ActivityMessageWidget(
        item: item.activityList[0],
        activity: item,
        hideResource: true,
      );
    }).toList();
  }

  @override
  CohortActivityController getController() {
    return CohortActivityController(type, cohortActivity);
  }

  @override
  String tag() {
    return "portal_$type";
  }

  @override
  bool displayNoDataWidget() => false;
}
