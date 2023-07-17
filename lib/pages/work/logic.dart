import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/getx/submenu_list/base_submenu_controller.dart';
import 'package:orginone/dart/core/getx/submenu_list/base_submenu_state.dart';
import 'package:orginone/dart/core/work/task.dart';
import 'package:orginone/event/work_reload.dart';
import 'package:orginone/main.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/toast_utils.dart';

import 'network.dart';
import 'state.dart';
import 'work_sub/logic.dart';

class WorkController extends BaseSubmenuController<WorkState> {
  final WorkState state = WorkState();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void initSubmenu() {
    // TODO: implement initSubmenu
    super.initSubmenu();
    state.submenu.value = [
      SubmenuType(text: "全部", value: 'all'),
      SubmenuType(text: "常用", value: 'common'),
      SubmenuType(text: "发起", value: 'create'),
      SubmenuType(text: "待办", value: 'todo'),
      SubmenuType(text: "已办", value: 'done'),
      SubmenuType(text: "我发起", value: 'apply'),
    ];
  }

  @override
  void onReady() {
    loadSuccess();
  }

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
     if(state.submenu[state.submenuIndex.value].value == "todo"){
       await settingCtrl.work.loadTodos(reload: true);
     }
     if(state.submenu[state.submenuIndex.value].value == "done"){
       WorkSubController workSubController = Get.find(tag: "work_done");
       workSubController.loadDones();
     }
     if(state.submenu[state.submenuIndex.value].value == "apply"){
       WorkSubController workSubController = Get.find(tag: "work_apply");
       workSubController.loadApply();
     }
    super.loadData(isRefresh: isRefresh, isLoad: isLoad);
  }

}
