import 'package:orginone/event/work_reload.dart';
import 'package:orginone/pages/other/work/network.dart';
import 'package:orginone/pages/other/work/state.dart';

import '../../../../dart/core/getx/base_list_controller.dart';
import 'state.dart';

class ProcessApprovalController
    extends BaseListController<ProcessApprovalState> {
  final ProcessApprovalState state = ProcessApprovalState();

  late WorkEnum type;

  ProcessApprovalController(this.type);
  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
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

    state.dataList.value = await WorkNetWork.getApproveTask(type: type.label);
    loadSuccess();
  }
}
