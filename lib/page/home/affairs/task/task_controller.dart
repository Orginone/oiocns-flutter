import 'package:orginone/api_resp/task_entity.dart';
import 'package:orginone/page/home/affairs/base/affairs_base_list_controller.dart';
import '../../../../api/workflow_api.dart';

class TaskController extends AffairsBaseListController<TaskEntity> {
  @override
  void onLoadMore() async {
    var pageResp = await WorkflowApi.task(limit, offset += 1, 'string');
    addData(true, pageResp);
  }

  @override
  void onRefresh() async {
    var pageResp = await WorkflowApi.task(limit, offset, 'string');
    addData(true, pageResp);
    // if(_controller != null && _controller!.spaces != null && _controller!.spaces.isNotEmpty){
    //   for (var value in _controller!.spaces) {
    //     print('--->' + value.name);
    //   }
    // }
  }

  //审批
   void approval() async{
    // var pageResp = await WorkflowApi.reject(limit, offset, 'string');
    // addData(true, pageResp);
  }
}
