import 'package:get/get.dart';
import 'package:orginone/api_resp/task_entity.dart';
import 'package:orginone/page/home/affairs/base/affairs_base_list_controller.dart';
import '../../../../api/workflow_api.dart';

class TaskController extends AffairsBaseListController<TaskEntity> {
  String typeName = "approve";

  @override
  void onLoadMore() async {
    await WorkflowApi.task(limit, offset += 1, 'string', typeName)
        .then((pageResp) {
      addData(false, pageResp);
    }).onError((error, stackTrace) {
      refreshController.loadFailed();
    }).whenComplete(() {});
  }

  @override
  void onRefresh() async {
    await WorkflowApi.task(limit, offset, 'string', typeName)
        .then((pageResp) {
          addData(true, pageResp);
        })
        .onError((error, stackTrace) {})
        .whenComplete(() {});
  }

  //审批
  void approval() async {
    // var pageResp = await WorkflowApi.reject(limit, offset, 'string');
    // addData(true, pageResp);
  }
}
