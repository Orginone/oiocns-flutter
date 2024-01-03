import 'package:orginone/dart/core/consts.dart';
import 'package:orginone/dart/core/getx/base_list_controller.dart';
import 'package:orginone/dart/core/work/task.dart';
import 'package:orginone/main.dart';
import 'package:orginone/pages/work/initiate_work/state.dart';
import 'package:orginone/utils/index.dart';

import 'state.dart';

class WorkListController extends BaseListController<WorkListState> {
  @override
  final WorkListState state = WorkListState();

  @override
  void onReceivedEvent(event) async {
    super.onReceivedEvent(event);
    if (event is WorkReload) {
      await loadData();
    }
  }

//群 办事列表
  @override
  Future<void> loadData({bool isRefresh = false, bool isLoad = false}) async {
    switch (state.work.workEnum) {
      case WorkEnum.todo:
        var todos = await relationCtrl.work.loadTodos();
        state.dataList.value = todos
            .where((element) =>
                element.metadata.belongId ==
                state.work.space?.metadata.belongId)
            .toList();
        break;
      case WorkEnum.completed:
        List<IWorkTask> res =
            await relationCtrl.work.loadContent(TaskType.done);
        state.dataList.value = res;
        break;
      case WorkEnum.initiated:
        List<IWorkTask> res =
            await relationCtrl.work.loadContent(TaskType.create);
        state.dataList.value = res;
        break;
      default:
    }
    super.loadData();
  }
}
