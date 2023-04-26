import 'package:orginone/event/home_data.dart';
import 'package:orginone/event/work_reload.dart';
import 'package:orginone/pages/work/network.dart';
import 'package:orginone/pages/work/state.dart';

import '../../../../dart/core/getx/base_list_controller.dart';
import 'state.dart';

class ProcessApprovalController
    extends BaseListController<ProcessApprovalState> {
  final ProcessApprovalState state = ProcessApprovalState();

  late WorkEnum type;

  ProcessApprovalController(this.type);

  @override
  void onReceivedEvent(event) async{
    // TODO: implement onReceivedEvent
    super.onReceivedEvent(event);
    if(event is WorkReload || event is InitHomeData){
      await loadData();
    }
  }

  @override
  Future<void> loadData({bool isRefresh = false, bool isLoad = false}) async {
    if(type == WorkEnum.done || type == WorkEnum.completed){
      state.dataList.value = await WorkNetWork.getRecord(type == WorkEnum.done?[1]:[100,200]);
    }else{
      state.dataList.value = await WorkNetWork.getApproveTask(type: type.label);
    }
    loadSuccess();
  }

  void approval(String id,int status) async{
    await WorkNetWork.approvalTask(id: id??"", status: status,comment: '');
  }

}
