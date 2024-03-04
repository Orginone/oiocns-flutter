// ignore_for_file: overridden_fields

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/components/widgets/form/form_widget/form_tool.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:orginone/pages/work/work_tool.dart';
import 'package:orginone/utils/index.dart';
import 'state.dart';

class ProcessDetailsController extends BaseController<ProcessDetailsState>
    with GetTickerProviderStateMixin {
  @override
  final ProcessDetailsState state = ProcessDetailsState();

  ProcessDetailsController() {
    state.tabController = TabController(length: tabTitle.length, vsync: this);
  }

  @override
  void onInit() {
    // LogUtil.d(
    //     'ProcessDetailsController taskdata：${jsonEncode(state.todo!.taskdata)}');
    // LogUtil.d(
    //     'ProcessDetailsController instance:${jsonEncode(state.todo!.instance)}');

    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
    LogUtil.d('ProcessDetailsController onReady');
    // LoadingDialog.showLoading(context, msg: '加载中...');
    await loadDataInfo();
    // LoadingDialog.dismiss(context);
  }

  void showAllProcess() {
    state.hideProcess.value = false;
  }

  Future<void> loadDataInfo() async {
    state.node = WorkTool.getNodeByNodeId(
        state.todo?.instanceData?.node?.id ?? "",
        node: state.todo?.instanceData?.node);
    if (state.node != null) {
      state.mainForm.value = state.node!.primaryForms ?? [];

      // state.mainForm.value = state.node!.forms
      //         ?.where((element) => element.typeName == "主表")
      //         .toList() ??
      //     [];
      state.mainTabController =
          TabController(length: state.mainForm.length, vsync: this);
      for (var element in state.mainForm) {
        element.data = getFormData(element.id);
        element.fields = state.todo?.instanceData?.fields?[element.id] ?? [];
        for (var field in element.fields) {
          field.field = await FormTool.initFields(field);
        }
      }
      state.subForm.value = state.node!.detailForms ?? [];
      // state.subForm.value = state.node!.forms
      //         ?.where((element) => element.typeName == "子表")
      //         .toList() ??
      //     [];
      state.subTabController =
          TabController(length: state.subForm.length, vsync: this);
      for (var element in state.subForm) {
        element.data = getFormData(element.id);
        element.fields = state.todo?.instanceData?.fields?[element.id] ?? [];
        for (var field in element.fields) {
          field.field = await FormTool.initFields(field);
        }
      }

      state.mainForm.refresh();
      state.subForm.refresh();
    }
  }

  FormEditData getFormData(String id) {
    final source = <AnyThingModel>[];
    if (state.todo?.instanceData?.data != null &&
        state.todo?.instanceData?.data![id] != null) {
      final beforeData = state.todo?.instanceData!.data![id]!;
      if (beforeData != null) {
        final nodeData =
            beforeData.where((i) => i.nodeId == state.node?.id).toList();
        if (nodeData.isNotEmpty) {
          return nodeData.last;
        }
      }
    }
    var data = FormEditData(
      nodeId: state.node?.id,
      // creator: belong.userId,
      createTime: DateTime.now().format(format: 'yyyy-MM-dd hh:mm:ss.S'),
      before: [], after: [],
    );
    data.before = List.from(source);
    data.after = List.from(source);
    return data;
  }
}
