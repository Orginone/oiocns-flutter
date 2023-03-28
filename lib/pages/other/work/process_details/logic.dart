import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:orginone/pages/other/work/network.dart';
import 'package:orginone/util/common_tree_management.dart';
import 'package:orginone/util/toast_utils.dart';
import 'package:orginone/widget/loading_dialog.dart';

import 'state.dart';

class ProcessDetailsController extends BaseController<ProcessDetailsState> with GetTickerProviderStateMixin{
  final ProcessDetailsState state = ProcessDetailsState();

  ProcessDetailsController(){
    state.tabController = TabController(length: tabTitle.length, vsync: this);
  }

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
    LoadingDialog.showLoading(context);

    state.flowInstance.value ??= await WorkNetWork.getFlowInstance(id: state.task.instanceId ?? "");
    await loadDataInfo();
    LoadingDialog.dismiss(context);
  }

  void showAllProcess() {
    state.hideProcess.value = false;
  }

  Future<void> loadDataInfo() async {

    if (state.flowInstance.value == null) {
      return;
    }
    Map<String, dynamic> data = jsonDecode(state.flowInstance.value?.data ?? "");
    if (data.isEmpty) {
      return;
    }
    try{
      for (var element in state.flowInstance.value!.flowTaskHistory!) {
        if(element.flowNode?.bindOperations!=null){
          for (var bindOperation in element.flowNode!.bindOperations!) {
            Map<String, Map<XAttribute, dynamic>> bindOperationInfo = {bindOperation.name!: {}};
            for (var key in data.keys) {
              XAttribute? x = await CommonTreeManagement().findXAttribute(
                  specieId: bindOperation.speciesId ?? "", attributeId: key);
              if (x != null) {
                bindOperationInfo[bindOperation.name!]!.addAll({x: data[key]});
              }
            }
            state.xAttribute.addAll(bindOperationInfo);
          }
        }
      }
      state.xAttribute.refresh();
    }catch(e){
       ToastUtils.showMsg(msg: e.toString());
    }
  }


}
