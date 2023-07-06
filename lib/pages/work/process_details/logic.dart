import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:orginone/main.dart';
import 'package:orginone/pages/work/network.dart';
import 'package:orginone/util/date_utils.dart';
import 'package:orginone/widget/loading_dialog.dart';
import 'package:orginone/model/thing_model.dart' as thing;
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
    await loadDataInfo();
    LoadingDialog.dismiss(context);
  }

  void showAllProcess() {
    state.hideProcess.value = false;
  }


  WorkNodeModel? getNodeByNodeId(String id, {WorkNodeModel? node}) {
    if (node != null) {
      if (id == node.id) return node;
      final find = getNodeByNodeId(id, node: node.children);
      if (find != null) return find;
      for (final subNode in node.branches ?? []) {
        final find = getNodeByNodeId(id, node: subNode.children);
        if (find != null) return find;
      }
    }
    return null;
  }

  Future<void> loadDataInfo() async {
    state.node = getNodeByNodeId(state.todo.instanceData?.node?.id??"", node: state.todo.instanceData?.node);
    if(state.node!=null){
      state.mainForm.value = state.node!.forms?.firstWhere((element) => element.typeName == "主表");
      state.mainForm.value!.data = getFormData(state.mainForm.value!.id!);
      state.mainForm.value!.fields = state.todo.instanceData!.fields[state.mainForm.value!.id]??[];
      for (var field in state.mainForm.value!.fields) {
        field.fields = field.initFields();
      }
      state.subForm.value = state.node!.forms?.where((element) => element.typeName == "子表").toList()??[];
      for (var element in state.subForm) {
        element.data = getFormData(element.id!);
        element.fields = state.todo.instanceData!.fields[element.id]??[];
        for (var field in element.fields) {
          field.fields = field.initFields();
        }
      }
      state.subTabController = TabController(length: state.subForm.length, vsync: this);
      state.mainForm.refresh();
      state.subForm.refresh();
    }
  }

  FormEditData getFormData(String id) {
    final source = <AnyThingModel>[];
    if (state.todo.instanceData?.data != null && state.todo.instanceData?.data[id] != null) {
      final beforeData = state.todo.instanceData!.data[id]!;
      if (beforeData.isNotEmpty) {
        final nodeData = beforeData.where((i) => i.nodeId == state.node?.id).toList();
        if (nodeData.isNotEmpty) {
          return nodeData.last;
        }
      }
    }
    var data = FormEditData(
      nodeId: state.node?.id,
      // creator: belong.userId,
      createTime: DateTime.now().format(format: 'yyyy-MM-dd hh:mm:ss.S'),
    );
    data.before = List.from(source);
    data.after =  List.from(source);
    return data;
  }
}
