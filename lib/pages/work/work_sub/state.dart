


import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/work/task.dart';
import 'package:orginone/pages/work/initiate_work/state.dart';

class WorkSubState extends BaseGetState{
  WorkBreadcrumbNav? nav;

  var list = <IWorkTask>[].obs;
}