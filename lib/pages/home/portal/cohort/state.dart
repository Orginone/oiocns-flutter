import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:orginone/dart/core/chat/activity.dart';
import 'package:orginone/dart/core/getx/base_get_list_state.dart';
import 'package:orginone/pages/chat/message_routers.dart';

class CohortActivityState extends BaseGetListState {
  ChatBreadcrumbNav? nav;

  ScrollController scrollController = ScrollController();
  //群动态信息
  late Rx<GroupActivity> cohortActivity;
  RxList<IActivityMessage> activityMessageList = <IActivityMessage>[].obs;
  //
}
