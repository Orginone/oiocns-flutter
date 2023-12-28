import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/widgets/TargetActivity/activity_message.dart';
import 'package:orginone/components/widgets/team_avatar.dart';
import 'package:orginone/config/unified.dart';
import 'package:orginone/dart/core/chat/activity.dart';
import 'package:orginone/dart/core/getx/base_get_list_page_view.dart';
import 'package:orginone/dart/base/model.dart' as model;

import 'controller.dart';
import 'state.dart';

//动态页面
class CohortActivityPage
    extends BaseGetListPageView<CohortActivityController, CohortActivityState> {
  late String type;
  late String label;
  late GroupActivity cohortActivity;
  late ScrollController scrollController;

  CohortActivityPage(this.type, this.label, this.cohortActivity, {super.key}) {
    scrollController = ScrollController();
    state.currentActivity = cohortActivity.activitys.first.obs;
  }

  @override
  Widget buildView() {
    return ExtendedNestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        state.activityMessageList.value =
            state.currentActivity.value.activitys.first.activityList ?? [];
        return [
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(
                  top: 10.h, left: 10.w, right: 10.w, bottom: 12.w),
              child: Row(
                children: activityGroup(controller.cohortActivity),
              ),
            ),
          ),
        ];
      },
      onlyOneScrollInBody: true,
      pinnedHeaderSliverHeightBuilder: () {
        return 0;
      },
      body: Obx(() {
        return Container(
          color: XColors.bgListBody,
          child: ListView(
              controller: scrollController,
              children: GroupActivityItem(
                  cohortActivity: controller.cohortActivity,
                  activity: controller.cohortActivity.activitys.isNotEmpty
                      ? controller.cohortActivity.activitys.first
                      : null)),
        );
      }),
    );
  }

  //渲染动态列表
  List<Widget> GroupActivityItem(
      {required GroupActivity cohortActivity, IActivity? activity}) {
    return state.activityMessageList.map((item) {
      return ActivityMessageWidget(
        item: item,
        activity: item.activity,
        hideResource: true,
      );
    }).toList();
  }

  List<Widget> activityGroup(GroupActivity activity) {
    return activity.activitys
        .where((item) => item.activityList.isNotEmpty)
        .map((item) {
      return Padding(
        padding: EdgeInsets.only(left: 8.w, right: 8.w),
        child: GestureDetector(
            onTap: () {
              state.currentActivity.value = item;
              state.activityMessageList.value = item.activityList;
              scrollController.reactive;
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                TeamAvatar(
                  info: TeamTypeInfo(
                      share: item.metadata.shareIcon() ??
                          model.ShareIcon(
                              name: '', typeName: item.typeName ?? "")),
                  size: 45.w,
                ),
                SizedBox(
                    width: 100.w,
                    child: Text(item.metadata.name!,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        )))
              ],
            )),
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
