import 'package:orginone/dart/base/api/workflow_api.dart';
import 'package:orginone/dart/base/model/record_task_entity.dart';
import 'package:orginone/pages/work/affairs/base/affairs_base_list_controller.dart';

class RecordController extends AffairsBaseListController<RecordTaskEntity> {
  @override
  void onLoadMore() async {
    await WorkflowApi.record(limit, offset += 1, 'string').then((pageResp) {
      addData(false, pageResp);
    }).onError((error, stackTrace) {
      refreshController.loadFailed();
    }).whenComplete(() {});
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
