import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_list_state.dart';
import 'package:orginone/dart/core/work/task.dart';
import 'package:orginone/pages/work/initiate_work/state.dart';

class WorkSubState extends BaseGetListState {
  WorkBreadcrumbNav? nav;

  RxList<IWorkTask> list = <IWorkTask>[].obs;

  late ScrollController scrollController;
}
