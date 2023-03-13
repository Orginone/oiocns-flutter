import 'package:get/get.dart';
import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/event/load_assets.dart';
import 'package:orginone/model/asset_creation_config.dart';
import 'package:orginone/util/event_bus_helper.dart';
import 'package:orginone/util/hive_utils.dart';
import 'package:orginone/util/toast_utils.dart';
import 'package:orginone/widget/loading_dialog.dart';

class ClaimNetWork {
  static Future<void> creteClaim(
      {required List<Fields> basic,
      required List<Config> detail,
      bool isDraft = false,
      bool isEdit = false}) async {
    basic.map((e) => e.toUploadJson()).toList();
    Map<String, dynamic> data = {
      "status": isDraft ? 0 : 1,
      "UPDATE_TIME": DateTime.now().toString(),
      "CREATE_TIME": DateTime.now().toString(),
      "SUBMITTER_NAME": HiveUtils.getUser()?.userName ?? "",
    };
    for (var element in basic) {
      data.addAll(element.toUploadJson());
    }
    List<Map<String, dynamic>> details = [];
    for (var element in detail) {
      Map<String, dynamic> data = {};
      for (var element1 in element.fields!) {
        data.addAll(element1.toUploadJson());
      }
      details.add(data);
    }

    data["approvalDocument"] = {
      "details": details,
    };

    ResultType result;
    if (isEdit) {
      result = await KernelApi.getInstance().anystore.update(
          "asset_receive",
          {
            "match": {
              "BILL_CODE": data['BILL_CODE'],
            },
            "update": {
              "_set_": data,
            }
          },
          "company");
    } else {
      result = await KernelApi.getInstance()
          .anystore
          .insert("asset_receive", data, "company");
    }

    if (result.success) {
      ToastUtils.showMsg(msg: "提交成功");
      EventBusHelper.fire(LoadAssets());
      Get.back();
    } else {
      LoadingDialog.dismiss(Get.context!);
    }
  }
}
