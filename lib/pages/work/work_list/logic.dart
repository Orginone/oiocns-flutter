import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_list_controller.dart';
import 'package:orginone/event/work_reload.dart';
import 'package:orginone/pages/work/initiate_work/state.dart';
import 'package:orginone/pages/work/network.dart';
import 'package:orginone/routers.dart';

import 'state.dart';

class WorkListController extends BaseListController<WorkListState> {
 final WorkListState state = WorkListState();

  void createWork() {
    Get.toNamed(Routers.workStart, arguments: {"data": state.work});
  }

 @override
 void onReceivedEvent(event) async{
   // TODO: implement onReceivedEvent
   super.onReceivedEvent(event);
   if(event is WorkReload){
     await loadData();
   }
 }

  @override
  Future<void> loadData({bool isRefresh = false, bool isLoad = false}) async {
    switch (state.work.workEnum!) {
      case WorkEnum.todo:
        var todo = await WorkNetWork.getTodo();
        state.dataList.value = todo
            .where((element) =>
                element.belongId == state.work.space?.metadata.belongId)
            .toList();
        break;
      case WorkEnum.completed:
        state.dataList.value =
            await WorkNetWork.getDones(state.work.space?.metadata.id ?? "");
        break;
      case WorkEnum.initiated:
        state.dataList.value =
            await WorkNetWork.getApply(state.work.space?.metadata.id ?? "");
        break;
    }
    state.dataList.refresh();
    loadSuccess();
  }
}
