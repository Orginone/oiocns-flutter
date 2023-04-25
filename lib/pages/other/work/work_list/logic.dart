import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:orginone/routers.dart';

import 'state.dart';

class WorkListController extends BaseController<WorkListState> {
 final WorkListState state = WorkListState();

  void createWork() {
    Get.toNamed(Routers.workStart, arguments: {"data": state.work});
  }
}
