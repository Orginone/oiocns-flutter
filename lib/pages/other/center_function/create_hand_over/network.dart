


import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/event/load_assets.dart';
import 'package:orginone/model/assets_info.dart';
import 'package:orginone/util/asset_management.dart';
import 'package:orginone/util/event_bus_helper.dart';
import 'package:orginone/util/hive_utils.dart';
import 'package:orginone/util/toast_utils.dart';

class HandOverNetWork{
  static createHandOver({
    required String billCode, XTarget? user,required String remark
    ,required List<AssetsInfo> assets,bool isDraft = false,bool isEdit = false}) async{


    List<UpdateAssetsRequest> request = assets
        .map((element) =>
        UpdateAssetsRequest(assetCode: element.assetCode!, updateData: {
          "USER_NAME": user?.name??"",
          "USER":user?.id??"",
          "KAPIANZT": CardStatus.handOver.toStatusId,
        }))
        .toList();

    await AssetManagement().updateAssetsForList(request);
    Map<String,dynamic> data = {
      "BILL_CODE":billCode,
      "SUBMITTER_NAME":HiveUtils.getUser()?.person?.name,
      "USER_NAME":user?.name??"",
      "APPLY_REMARK":remark,
      "CREATE_USER": HiveUtils.getUser()?.person?.id,
      "CREATE_TIME": DateTime.now().toString(),
      "UPDATE_TIME": DateTime.now().toString(),
      "status": isDraft?0:1,
      "approvalDocument": {
        "SUBMITTER_NAME":HiveUtils.getUser()?.person?.name,
        "USER_NAME":user?.name??"",
        "detail": assets.map((e) => e.toJson()).toList(),
      }
    };

   ResultType resultType;

   if(isEdit){
     resultType = await KernelApi.getInstance().anystore.update("asset_restore",{
       "match":{
         "BILL_CODE":billCode,
       },
       "update":{
         "_set_":data,
       }
     },"company");
   }else{
     resultType = await KernelApi.getInstance().anystore.insert("asset_restore", data,"company");
   }

   if(resultType.success){
     ToastUtils.showMsg(msg: "提交成功");
     EventBusHelper.fire(LoadAssets());
     Get.back();
   }else{
     ToastUtils.showMsg(msg: "提交失败:${resultType.msg}");
   }
  }

}