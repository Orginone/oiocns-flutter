import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/main.dart';
import 'package:orginone/pages/work/network.dart';

import '../../../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class ProcessInfoController extends BaseController<ProcessInfoState> {
  final ProcessInfoState state = ProcessInfoState();

  void approval(int status) async {
    await WorkNetWork.approvalTask(
        status: status,
        comment: state.comment.text,
        todo: state.todo,
        onSuccess: () {
          Get.back();
        });
  }

  Future<bool> loadFieldData(
      FieldModel field, Map<String, dynamic> data) async {
    var value = data[field.id];
    if (field.field.type == "input") {
      field.field.controller!.text = value ?? "";
    } else {
      switch (field.field.type) {
        case "selectPerson":
        case "selectDepartment":
        case "selectGroup":
          field.field.defaultData.value =
              await settingCtrl.user.findShareById(value);
          break;
        case "select":
        case 'switch':
          field.field.select = {};
          for (var value in field.lookups??[]) {
            field.field.select![value.value] = value.text ?? "";
          }
          if(field.field.type == "select"){
            field.field.defaultData.value = {value:field.field.select![value]};
          }else{
            field.field.defaultData.value = value??"";
          }
          break;
        case "upload":
          field.field.defaultData.value = FileItemModel.fromJson(value??{});
          break;
        default:
          field.field.defaultData.value = value ?? "";
          break;
      }
    }
    return true;
  }
}
