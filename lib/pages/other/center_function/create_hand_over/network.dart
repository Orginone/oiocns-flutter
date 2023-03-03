


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

class HandOverNetWork{
  static createHandOver({
    required String billCode,required String userName,required String remark
    ,required List<MyAssetsList> assets,bool isDraft = false}) async{

    Map<String, dynamic> user = {"value": userName};
    List<UpdateAssetsRequest> request = assets
        .map((element) =>
        UpdateAssetsRequest(assetCode: element.assetCode!, updateData: {
          "USER": user,
          "KAPIANZT": "12",
        }))
        .toList();

    await AssetManagement().updateAssetsForList(request);

   ResultType resultType =  await KernelApi.getInstance().anystore.insert("asset_transfer", {
      "BILL_CODE":billCode,
      "SUBMITTER_NAME":HiveUtils.getUser()?.person?.name,
      "USER_NAME":userName,
      "APPLY_REMARK":remark,
      "CREATE_USER": HiveUtils.getUser()?.person?.id,
      "submitUserName": HiveUtils.getUser()?.person?.name,
      "CREATE_TIME": DateTime.now().toString(),
      "UPDATE_TIME": DateTime.now().toString(),
      "status": isDraft?0:1,
      "approvalDocument": {
        "SUBMITTER_NAME":HiveUtils.getUser()?.person?.name,
        "USER_NAME":userName,
        "detail": assets.map((e) => e.toJson()).toList(),
      }
    },"company");

   if(resultType.success){
     ToastUtils.showMsg(msg: "提交成功");
     EventBusHelper.fire(LoadAssets());
     Get.back();
   }else{
     ToastUtils.showMsg(msg: "提交失败:${resultType.msg}");
   }
  }

}