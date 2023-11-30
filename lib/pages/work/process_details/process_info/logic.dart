import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/consts.dart';
import 'package:orginone/main.dart';
import 'package:orginone/utils/index.dart';

import '../../../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class ProcessInfoController extends BaseController<ProcessInfoState> {
  @override
  final ProcessInfoState state = ProcessInfoState();

  @override
  void onInit() {
    super.onInit();
    LogUtil.d(state.todo);
  }

  Future<bool> loadMainFieldData(
      FieldModel field, Map<String, dynamic> data) async {
    var value = data[field.id];
    if (value == null) {
      return false;
    }
    await _buildField(field, value);
    return true;
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
          field.field.defaultData.value = settingCtrl.user.findShareById(value);
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

  Future<List<List<String>>> loadSubFieldData(
      XForm form, List<FieldModel> fields) async {
    List<List<String>> content = [];
    for (var thing in form.data!.after) {
      List<String> data = [
        thing.id ?? "",
        thing.status ?? "",
        ShareIdSet[thing.creater]?.name ?? "",
      ];
      for (var field in fields) {
        dynamic value = thing.otherInfo[field.id];
        if (value == null) {
          data.add('');
        } else {
          try {
            if (field.name!.contains("是否启用")) {
              LogUtil.d('');
            }
            data.add(await _buildField(field, thing.otherInfo[field.id]));
          } catch (e) {
            LogUtil.d('');
          }
        }
      }
      content.add(data);
    }
    return content;
  }

  void changeMainIndex(int index) {
    if (state.mainIndex.value != index) state.mainIndex.value = index;
  }

  void changeSubIndex(int index) {
    if (state.subIndex.value != index) state.subIndex.value = index;
  }
}
