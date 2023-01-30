import 'package:orginone/api_resp/task_entity.dart';
import 'package:orginone/page/home/affairs/base/affairs_base_list_controller.dart';
import '../../../../core/base/api/workflow_api.dart';
import '../../../../api_resp/record_task_entity.dart';

class RecordController extends AffairsBaseListController<RecordTaskEntity> {
  @override
  void onLoadMore() async {
    await WorkflowApi.record(limit, offset += 1, 'string')
        .then((pageResp) {
          addData(false, pageResp);
        })
        .onError((error, stackTrace) {
      refreshController.loadFailed();
    })
        .whenComplete(() {});
  }

  @override
  void onRefresh() async {
    await WorkflowApi.record(limit, offset, 'string')
        .then((pageResp) {
          addData(true, pageResp);
        })
        .onError((error, stackTrace) {})
        .whenComplete(() {});
  }
}
