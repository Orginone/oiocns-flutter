import 'package:orginone/config/constant.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/base_list_controller.dart';
import 'package:orginone/event/work_reload.dart';
import 'package:orginone/pages/store/state.dart';

import 'network.dart';
import 'state.dart';

class WorkController extends BaseListController<WorkState> {
  final WorkState state = WorkState();


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    state.recentlyList.add(
        Recent("0000", "资产监管", "${Constant.host}/img/logo/logo3.jpg"));
    state.recentlyList.add(
        Recent("0001", "资产处置", "${Constant.host}/img/logo/logo3.jpg"));
    state.recentlyList.add(
        Recent("0001", "通用表格", "${Constant.host}/img/logo/logo3.jpg"));
    state.recentlyList.add(
        Recent("0001", "公物仓", "${Constant.host}/img/logo/logo3.jpg"));
    state.recentlyList.add(
        Recent("0001", "公益仓", "${Constant.host}/img/logo/logo3.jpg"));
    state.recentlyList.add(
        Recent("0000", "资产监管", "${Constant.host}/img/logo/logo3.jpg"));
    state.recentlyList.add(
        Recent("0001", "资产处置", "${Constant.host}/img/logo/logo3.jpg"));
    state.recentlyList.add(
        Recent("0001", "通用表格", "${Constant.host}/img/logo/logo3.jpg"));
    state.recentlyList.add(
        Recent("0001", "公物仓", "${Constant.host}/img/logo/logo3.jpg"));
    state.recentlyList.add(
        Recent("0001", "公益仓", "${Constant.host}/img/logo/logo3.jpg"));
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

  void approval(XWorkTask todo, int status) async {
    await WorkNetWork.approvalTask(status: status, comment: '', todo: todo);
  }
}
