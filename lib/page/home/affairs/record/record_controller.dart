import 'package:orginone/api_resp/task_entity.dart';
import 'package:orginone/page/home/affairs/base/affairs_base_list_controller.dart';
import '../../../../api/workflow_api.dart';
import '../../../../api_resp/record_task_entity.dart';

class RecordController extends AffairsBaseListController<RecordTaskEntity> {
  @override
  void onLoadMore() async {
    var pageResp = await WorkflowApi.record(limit, offset += 1, 'string');
    addData(true, pageResp);
  }

  @override
  void onRefresh() async {
    var pageResp = await WorkflowApi.record(limit, offset, 'string');
    addData(true, pageResp);
  }
}
