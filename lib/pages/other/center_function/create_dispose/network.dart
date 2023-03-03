import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/event/load_assets.dart';
import 'package:orginone/model/my_assets_list.dart';
import 'package:orginone/util/asset_management.dart';
import 'package:orginone/util/event_bus_helper.dart';
import 'package:orginone/util/hive_utils.dart';
import 'package:orginone/util/toast_utils.dart';
import 'package:uuid/uuid_util.dart';

class DisposeNetwork {
  static Future<void> createDispose({required int way,
    required int keepOrgType,
    required String keepOrgName,
    required int evaluated,
    required String billCode,
    required List<MyAssetsList> assets,
    bool isDraft = false,
    String remark = "",int? phoneNumber}) async {
    List<UpdateAssetsRequest> request = assets
        .map((element) =>
        UpdateAssetsRequest(assetCode: element.assetCode!, updateData: {
          "KAPIANZT": "09",
        }))
        .toList();

    await AssetManagement().updateAssetsForList(request);

    double assetsTotal = 0;
    double count = 0;
    double netWorthTotal = 0;
    double depreciationTotal = 0;
    for (var element in assets) {
      assetsTotal += element.netVal ?? 0;
      netWorthTotal += element.netVal ?? 0;
      count += element.numOrArea ?? 0;
      depreciationTotal = double.tryParse(element.quderq??"0")??0;


    }
    ResultType resultType = await KernelApi
        .getInstance()
        .anystore
        .insert(
        "disposal",
        {
          "way": way,
          "IS_SYS_UNIT": keepOrgType,
          "APPLY_UNIT": keepOrgName,
          "keepOrgPhomeNumber":phoneNumber,
          "evaluated": evaluated,
          "SHEJIZCZZ": assetsTotal,
          "LEIJIZJHJ": depreciationTotal,
          "JINGZHIHJ": netWorthTotal,
          "count": count,
          "submitterName": HiveUtils
              .getUser()
              ?.person
              ?.name,
          "submitterId": HiveUtils
              .getUser()
              ?.person
              ?.id,
          "approvalEnd": 0,
          "approvalStatus": 3,
          "verificationStatus": 10,
          "readStatus": isDraft ? 0 : 1,
          "gmtCreate": DateTime.now().toString(),
          "id": UuidUtil.cryptoRNG().toString(),
          "detail": assets.map((e) => e.assetCode).toList(),
          "BILL_CODE": billCode,
          "REMARK": remark,
          "CREATE_USER": HiveUtils
              .getUser()
              ?.person
              ?.id,
          "submitUserName": HiveUtils
              .getUser()
              ?.person
              ?.name,
          "CREATE_TIME": DateTime.now().toString(),
          "UPDATE_TIME": DateTime.now().toString(),
        },
        "company");

    if (resultType.success) {
      ToastUtils.showMsg(msg: "提交成功");
      EventBusHelper.fire(LoadAssets());
      Get.back();
    } else {
      ToastUtils.showMsg(msg: "提交失败:${resultType.msg}");
    }
  }
}
