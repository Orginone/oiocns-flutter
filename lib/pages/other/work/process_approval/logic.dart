import 'package:orginone/event/home_data.dart';
import 'package:orginone/event/work_reload.dart';
import 'package:orginone/pages/other/work/network.dart';
import 'package:orginone/pages/other/work/state.dart';
import 'package:orginone/pages/other/work/to_do/state.dart';
import 'package:orginone/util/event_bus_helper.dart';

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
    if(type == WorkEnum.done){
      state.dataList.value = await WorkNetWork.getRecord();
    }else{
      state.dataList.value = await WorkNetWork.getApproveTask(type: type.label);
    }
    loadSuccess();
  }
}
