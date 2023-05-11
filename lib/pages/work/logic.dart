import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/base_list_controller.dart';
import 'package:orginone/event/work_reload.dart';

import 'network.dart';
import 'state.dart';

class WorkController extends BaseListController<WorkState> {
  final WorkState state = WorkState();

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
    state.dataList.value = await WorkNetWork.getTodo();
    loadSuccess();
  }

  void approval(XWorkTask todo, int status) async {
    await WorkNetWork.approvalTask(status: status, comment: '', todo: todo);
  }
}
