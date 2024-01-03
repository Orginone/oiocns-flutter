import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/common/models/file/index.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
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
    state.node = getNodeByNodeId(state.todo?.instanceData?.node?.id ?? "",
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
          field.field = await initFields(field);
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
          field.field = await initFields(field);
        }
      }

      state.mainForm.refresh();
      state.subForm.refresh();
    }
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

  Future<Fields> initFields(FieldModel field) async {
    String? type;
    String? router;
    String? regx;
    Map<dynamic, String> select = {};
    Map rule = jsonDecode(field.rule ?? "{}");
    String widget = rule['widget'] ?? "";
    switch (field.valueType) {
      case "描述型":
        type = "input";
        break;
      case "数值型":
        regx = r'[0-9]';
        type = "input";
        break;
      case "选择型":
      case "分类型":
        if (widget == 'switch') {
          type = "switch";
        } else {
          type = "select";
        }
        break;
      case "日期型":
        type = "selectDate";
        break;
      case "时间型":
        if (widget == "dateRange") {
          type = "selectDateRange";
        } else if (widget == "timeRange") {
          type = "selectTimeRange";
        } else {
          type = "selectTime";
        }
        break;
      case "用户型":
        if (widget.isEmpty) {
          type = "selectPerson";
        } else if (widget == 'group') {
          type = "selectGroup";
        } else if (widget == 'dept') {
          type = "selectDepartment";
        }
        break;
      case '附件型':
        type = "upload";
        break;
      default:
        type = 'input';
        break;
    }

    return Fields(
      title: field.name,
      type: type,
      code: field.code,
      select: select,
      router: router,
      regx: regx,
      readOnly: true,
    );
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
