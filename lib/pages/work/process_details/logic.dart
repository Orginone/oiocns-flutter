import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:orginone/pages/work/network.dart';
import 'package:orginone/util/toast_utils.dart';
import 'package:orginone/widget/loading_dialog.dart';

import 'state.dart';

class ProcessDetailsController extends BaseController<ProcessDetailsState> with GetTickerProviderStateMixin{
  final ProcessDetailsState state = ProcessDetailsState();

  ProcessDetailsController(){
    state.tabController = TabController(length: tabTitle.length, vsync: this);
  }

  SettingController get controller => Get.find();

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
    LoadingDialog.showLoading(context);

    state.workInstance.value ??= await WorkNetWork.getFlowInstance(state.todo.metadata.instanceId ?? "");
    await loadDataInfo();
    LoadingDialog.dismiss(context);
  }

  void showAllProcess() {
    state.hideProcess.value = false;
  }

  Future<void> loadDataInfo() async {

    if (state.workInstance.value == null) {
      return;
    }
    Map<String, dynamic> data = jsonDecode(state.workInstance.value?.data ?? "");
    if (data.isEmpty) {
      return;
    }
    try{
      var space =
          setting.user.companys.firstWhere((a) => a.belongId == state.todo.metadata.belongId);

      for (var element in state.workInstance.value!.historyTasks!) {
        // if(element.node?.bindOperations!=null){
        //   for (var bindOperation in element.node!.bindOperations!) {
        //     Map<String, Map<XOperationItem, dynamic>> bindOperationInfo = {bindOperation.name!: {}};
        //    List<XOperationItem> items = await WorkNetWork.getOperationItems(bindOperation.id??"",space.id);
        //     for (var item in items) {
        //       bindOperationInfo[bindOperation.name!]!.addAll({item: data['formData'][item.attrId]??""});
        //     }
        //     state.xAttribute.addAll(bindOperationInfo);
        //   }
        // }
      }
      state.xAttribute.refresh();
    }catch(e){
       ToastUtils.showMsg(msg: e.toString());
    }
  }


}
