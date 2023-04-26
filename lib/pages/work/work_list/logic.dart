import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:orginone/dart/core/getx/base_list_controller.dart';
import 'package:orginone/pages/work/network.dart';
import 'package:orginone/routers.dart';

import 'state.dart';

class WorkListController extends BaseListController<WorkListState> {
 final WorkListState state = WorkListState();

  void createWork() {
    Get.toNamed(Routers.workStart, arguments: {"data": state.work});
  }


  @override
  Future<void> loadData({bool isRefresh = false, bool isLoad = false}) async{
    var todo = await WorkNetWork.getTodo();
    state.dataList.value = todo.where((element) => element.spaceId == state.work.space?.id).toList();
    state.dataList.refresh();
    loadSuccess();
  }
}
