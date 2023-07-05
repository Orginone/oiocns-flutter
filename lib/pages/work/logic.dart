import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/frequently_used_list/base_freqiently_usedList_controller.dart';
import 'package:orginone/dart/core/work/task.dart';
import 'package:orginone/event/work_reload.dart';
import 'package:orginone/main.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/toast_utils.dart';

import 'network.dart';
import 'state.dart';

class WorkController extends BaseFrequentlyUsedListController<WorkState> {
  final WorkState state = WorkState();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    state.mostUsedList = settingCtrl.work.workFrequentlyUsed;
  }

  @override
  void onReceivedEvent(event) async{
    // TODO: implement onReceivedEvent
    super.onReceivedEvent(event);
    if(event is WorkReload){
      await loadData();
    }
  }

  @override
  Future<void> loadData({bool isRefresh = false, bool isLoad = false}) async {
    state.dataList.value = await WorkNetWork.getTodo();
    loadSuccess();
  }

  void approval(IWorkTask todo, int status) async {
    await WorkNetWork.approvalTask(status: status, comment: '', todo: todo);
  }

  @override
  void onTapFrequentlyUsed(used) async {
    if (used is WorkFrequentlyUsed) {
      WorkNodeModel? node = await used.define.loadWorkNode();
      if (node != null && node.forms != null && node.forms!.isNotEmpty) {
        Get.toNamed(Routers.createWork, arguments: {
          "define": used.define,
          "node": node,
          'target': settingCtrl.provider
              .findTarget(used.define.metadata.belongId ?? "")
        });
      } else {
        ToastUtils.showMsg(msg: "流程未绑定表单");
      }
    }
  }
}
