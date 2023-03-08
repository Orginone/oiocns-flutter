import 'package:get/get.dart';
import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/event/load_assets.dart';
import 'package:orginone/model/assets_info.dart';
import 'package:orginone/util/asset_management.dart';
import 'package:orginone/util/event_bus_helper.dart';
import 'package:orginone/util/hive_utils.dart';
import 'package:orginone/util/toast_utils.dart';
import 'package:orginone/widget/loading_dialog.dart';
import 'package:uuid/uuid_util.dart';

class DisposeNetwork {
  static Future<void> createDispose(
      {required int way,
      int? keepOrgType,
      required String keepOrgName,
      int? evaluated,
      required String billCode,
      required List<AssetsInfo> assets,
      bool isDraft = false,
      String remark = "",
      int? phoneNumber,
      bool isEdit = false}) async {


    double assetsTotal = 0;
    double count = 0;
    double netWorthTotal = 0;
    double depreciationTotal = 0;
    for (var element in assets) {
      assetsTotal += element.netVal ?? 0;
      netWorthTotal += element.netVal ?? 0;
      count += element.numOrArea ?? 0;
      depreciationTotal = double.tryParse(element.quderq ?? "0") ?? 0;
    }

    Map<String, dynamic> data = {
      "way": way,
      "IS_SYS_UNIT": keepOrgType,
      "APPLY_UNIT": keepOrgName,
      "keepOrgPhoneNumber": phoneNumber,
      "evaluated": evaluated,
      "SHEJIZCZZ": assetsTotal,
      "LEIJIZJHJ": depreciationTotal,
      "JINGZHIHJ": netWorthTotal,
      "count": count,
      "SUBMITTER_NAME": HiveUtils.getUser()?.person?.name,
      "SUBMITTER_ID": HiveUtils.getUser()?.person?.id,
      "approvalEnd": 0,
      "APPROVAL_STATUS": 3,
      "verificationStatus": 10,
      "readStatus": isDraft ? 0 : 1,
      "id": UuidUtil.cryptoRNG().toString(),
      "detail": assets.map((e) => e.assetCode).toList(),
      "BILL_CODE": billCode,
      "REMARK": remark,
      "CREATE_USER": HiveUtils.getUser()?.person?.id,
      "CREATE_TIME": DateTime.now().toString(),
      "UPDATE_TIME": DateTime.now().toString(),
    };

    ResultType resultType;
    if(!isDraft){
      List<UpdateAssetsRequest> request = assets
          .map((element) =>
          UpdateAssetsRequest(assetCode: element.assetCode!, updateData: {
            "KAPIANZT": CardStatus.dispose.toStatusId,
          }))
          .toList();

      await AssetManagement().updateAssetsForList(request);
    }

    if (isEdit) {
      resultType = await KernelApi.getInstance().anystore.update(
          "disposal",
          {
            "match": {
              "BILL_CODE": billCode,
            },
            "update": {
              "_set_": data,
            }
          },
          "company");
    } else {
      resultType = await KernelApi.getInstance()
          .anystore
          .insert("disposal", data, "company");
    }

    if (resultType.success) {
      ToastUtils.showMsg(msg: "提交成功");
      EventBusHelper.fire(LoadAssets());
      Get.back();
    } else {
      ToastUtils.showMsg(msg: "提交失败:${resultType.msg}");
    }
  }
}
