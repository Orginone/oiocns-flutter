import 'package:orginone/dart/base/api/workflow_api.dart';
import 'package:orginone/dart/base/model/instance_task_entity.dart';
import 'package:orginone/pages/work/affairs/base/affairs_base_list_controller.dart';

class InstanceController extends AffairsBaseListController<InstanceTaskEntity> {
  @override
  void onLoadMore() async {
    await WorkflowApi.instance(limit, offset += 1, 'string').then((pageResp) {
      addData(false, pageResp);
    }).onError((error, stackTrace) {
      refreshController.loadFailed();
    }).whenComplete(() {});
  }

  @override
  void onRefresh() async {
    await WorkflowApi.instance(limit, offset, 'string')
        .then((pageResp) {
          addData(true, pageResp);
        })
        .onError((error, stackTrace) {})
        .whenComplete(() {
          refreshController.refreshCompleted();
        });
  }

  void deleteInstance(int index, InstanceTaskEntity item) async {
    await WorkflowApi.deleteInstance(item.id)
        .then((pageResp) {
          removeAt(index);
        })
        .onError((error, stackTrace) {})
        .whenComplete(() {});
  }
}
