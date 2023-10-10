import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/getx/base_list_controller.dart';
import 'package:orginone/dart/core/work/task.dart';
import 'package:orginone/event/work_reload.dart';
import 'package:orginone/main.dart';
import 'package:orginone/pages/work/initiate_work/state.dart';

import 'state.dart';

class WorkListController extends BaseListController<WorkListState> {
  @override
  final WorkListState state = WorkListState();

  @override
  void onReceivedEvent(event) async {
    // TODO: implement onReceivedEvent
    super.onReceivedEvent(event);
    if (event is WorkReload) {
      await loadData();
    }
  }

  @override
  Future<void> loadData({bool isRefresh = false, bool isLoad = false}) async {
    switch (state.work.workEnum!) {
      case WorkEnum.todo:
        var todo = await settingCtrl.work.loadTodos();
        state.dataList.value = todo
            .where((element) =>
                element.metadata.belongId ==
                state.work.space?.metadata.belongId)
            .toList();
        break;
      case WorkEnum.completed:
        PageResult<IWorkTask> pageResult =
            await settingCtrl.work.loadDones(IdPageModel(
          id: state.work.space?.metadata.id ?? "",
        ));
        state.dataList.value = pageResult.result;
        break;
      case WorkEnum.initiated:
        PageResult<IWorkTask> pageResult =
            await settingCtrl.work.loadApply(IdPageModel(
          id: state.work.space?.metadata.id ?? "",
        ));
        state.dataList.value = pageResult.result;
        break;
    }
    super.loadData();
  }
}
