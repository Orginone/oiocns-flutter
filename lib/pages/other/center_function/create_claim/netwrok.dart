import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/event/load_assets.dart';
import 'package:orginone/pages/other/center_function/create_claim/state.dart';
import 'package:orginone/util/department_management.dart';
import 'package:orginone/util/event_bus_helper.dart';
import 'package:orginone/util/hive_utils.dart';
import 'package:orginone/util/toast_utils.dart';

class ClaimNetWork {
  static Future<void> creteClaim(
      {required String billCode,
      required String remark,
      required List<ClaimDetailed> detail,
      bool isDraft = false}) async {
    KernelApi.getInstance().anystore.insert(
        "asset_receive",
        {
          "BILL_CODE": billCode,
          "APPLY_REMARK": remark,
          "submitUserName": HiveUtils.getUser()?.userName ?? "",
          "approvalDocument":{
            "details":detail.map((e){
              return {
                "ASSET_TYPE": {"value": e.assetType!.name},
                "ASSET_NAME": e.assetNameController.text,
                "CREATE_USER": HiveUtils.getUser()?.person?.id ?? "",
                "submitUserName": HiveUtils.getUser()?.userName ?? "",
                "USERS": {"value": HiveUtils.getUser()?.userName ?? ""},
                "USE_DEPT": {
                  "value": DepartmentManagement().currentDepartment?.name ?? ""
                },
                "NUM_OR_AREA": int.tryParse(e.quantityController.text),
                "SPEC_MOD": e.modelController.text,
                "BRAND": e.brandController.text,
                "LOCATION": "",
                "isDistribution": e.isDistribution,
              };
            }).toList()
          },
          "status": isDraft ? 0 : 1,
          "UPDATE_TIME": DateTime.now().toString(),
          "CREATE_TIME": DateTime.now().toString(),
        },
        "company").then((value){
          if(value.success){
            ToastUtils.showMsg(msg: "提交成功");
            EventBusHelper.fire(LoadAssets());
            Get.back();
          }else{
            ToastUtils.showMsg(msg: "提交失败:${value.msg}");
          }
    });
  }
}
