import 'dart:convert';

import 'package:get/get.dart';
import 'package:orginone/common/models/file/index.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/work/task.dart';
import 'package:orginone/main_base.dart';
import 'package:orginone/utils/index.dart';

class FormWidgetController extends GetxController {
  FormWidgetController();

  //办事对象
  IWorkTask? todo;
  //办事节点
  WorkNodeModel? node;
  List<XForm> mainForm = [];
  List<XForm> subForm = [];

  _initData() async {
    todo = Get.arguments?['todo'];
    //加载数据
    await loadDataInfo();
    // LogUtil.d(todo);
    // LogUtil.d(mainForm);
    // LogUtil.d(subForm);
    update(["form_widget"]);
  }

  void onTap() {}

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  Future<String> _buildField(FieldModel field, dynamic value) async {
    if (field.field.type == "input") {
      field.field.controller!.text = (value ?? "").toString();
      return value.toString() ?? "";
    } else {
      switch (field.field.type) {
        case "selectPerson":
        case "selectDepartment":
        case "selectGroup":
          field.field.defaultData.value =
              relationCtrl.user?.findShareById(value);
          return field.field.defaultData.value.name;
        case "select":
        case 'switch':
          field.field.select = {};
          for (var value in field.lookups ?? []) {
            field.field.select![value.value] = value.text ?? "";
          }
          if (field.field.type == "select") {
            field.field.defaultData.value = {value: field.field.select![value]};
          } else {
            field.field.defaultData.value = value ?? "";
          }
          return field.field.select![value] ?? "";
        case "upload":
          field.field.defaultData.value =
              value != null ? FileItemModel.fromJson(value) : null;
          return field.field.defaultData.value.name;
        default:
          field.field.defaultData.value = value;
          if (field.field.type == "selectTimeRange" ||
              field.field.type == "selectDateRange") {
            return field.field.defaultData.value.join("至");
          }
          return value ?? "";
      }
    }
  }

  Future<void> loadDataInfo() async {
    node = getNodeByNodeId(todo?.instanceData?.node?.id ?? "",
        node: todo?.instanceData?.node);
    if (node != null) {
      mainForm = node!.primaryForms ?? [];

      // state.mainForm.value = state.node!.forms
      //         ?.where((element) => element.typeName == "主表")
      //         .toList() ??
      //     [];
      // state.mainTabController =
      //     TabController(length: state.mainForm.length, vsync: this);
      for (var element in mainForm) {
        element.data = getFormData(element.id);
        element.fields = todo?.instanceData?.fields?[element.id] ?? [];
        for (var field in element.fields) {
          field.field = await initFields(field);
        }
      }
      subForm = node!.detailForms ?? [];
      // state.subForm.value = state.node!.forms
      //         ?.where((element) => element.typeName == "子表")
      //         .toList() ??
      //     [];
      // subTabController =
      //     TabController(length: subForm.length, vsync: this);
      for (var element in subForm) {
        element.data = getFormData(element.id);
        element.fields = todo?.instanceData?.fields?[element.id] ?? [];
        for (var field in element.fields) {
          field.field = await initFields(field);
        }
      }

      // mainForm.refresh();
      // subForm.refresh();
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
    if (todo?.instanceData?.data != null &&
        todo?.instanceData?.data![id] != null) {
      final beforeData = todo?.instanceData!.data![id]!;
      if (beforeData != null) {
        final nodeData = beforeData.where((i) => i.nodeId == node?.id).toList();
        if (nodeData.isNotEmpty) {
          return nodeData.last;
        }
      }
    }
    var data = FormEditData(
      nodeId: node?.id,
      // creator: belong.userId,
      createTime: DateTime.now().format(format: 'yyyy-MM-dd hh:mm:ss.S'),
      before: [], after: [],
    );
    data.before = List.from(source);
    data.after = List.from(source);
    return data;
  }
  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
