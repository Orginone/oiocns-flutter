


import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/pages/other/work/initiate_work/state.dart';

class WorkListState extends BaseGetState {
  late WorkBreadcrumbNav data;

  WorkListState() {
    data = Get.arguments['data'];
  }
}