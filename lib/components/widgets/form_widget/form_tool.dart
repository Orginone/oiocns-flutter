import 'dart:convert';

import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/public/entity.dart';
import 'package:orginone/main_base.dart';
import 'package:orginone/utils/index.dart';

class FormTool {
  static Future<bool> loadMainFieldData(
      FieldModel field, Map<String, dynamic> data) async {
    var value = data[field.id];
    if (value == null) {
      return false;
    }
    await buildField(field, value);
    return true;
  }

  static Future<List<List<String>>> loadSubFieldData(
      XForm form, List<FieldModel> fields) async {
    List<List<String>> content = [];
    for (var thing in form.data!.after) {
      List<String> data = [
        // thing.id ?? thing.otherInfo['id'] ?? '',
        // thing.status ?? "",
        // ShareIdSet[thing.creater]?.name ?? "",
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
            data.add(await buildField(field, thing.otherInfo[field.id]));
          } catch (e) {
            LogUtil.d(e.toString());
          }
        }
      }
      content.add(data);
    }
    return content;
  }

  static Future<List<List<String>>> loadOldSubFieldData(
      XForm form, List<FieldModel> fields) async {
    List<List<String>> content = [];
    for (var thing in form.data!.after) {
      List<String> data = [
        thing.id ?? thing.otherInfo['id'] ?? '',
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
            data.add(await buildField(field, thing.otherInfo[field.id]));
          } catch (e) {
            LogUtil.d(e.toString());
          }
        }
      }
      content.add(data);
    }
    return content;
  }

  static Future<String> buildField(FieldModel field, dynamic value) async {
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
          // LogUtil.d("file");

          // LogUtil.d(jsonDecode(value));
          // LogUtil.d(value.runtimeType);
          if (value == null) {
            return '';
          }
          value = jsonDecode(value);
          if (value is List && value.isEmpty) {
            return '';
          }
          // LogUtil.d(value);
          // LogUtil.d(value.runtimeType);
          value = value is Map
              ? value
              : value is List && value.isNotEmpty
                  ? value[0]
                  : value;
          var file = field.field.defaultData.value =
              value != null ? FileItemModel.fromJson(value) : null;
          // LogUtil.d(value);
          // LogUtil.d(value.runtimeType);
          // LogUtil.d(file);
          // return field.field.defaultData.value.name ?? '';
          return file?.name ?? '';
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
}
