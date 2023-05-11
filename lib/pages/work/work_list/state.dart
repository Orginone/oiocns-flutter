


import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/base_get_list_state.dart';
import 'package:orginone/pages/work/initiate_work/state.dart';

class WorkListState extends BaseGetListState<XWorkTask> {
  late WorkBreadcrumbNav work;
  WorkListState() {
    work = Get.arguments['data'];
  }
}