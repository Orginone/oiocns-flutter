


import 'package:get/get.dart';
import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/event/load_assets.dart';
import 'package:orginone/model/asset_creation_config.dart';
import 'package:orginone/model/assets_info.dart';
import 'package:orginone/util/asset_management.dart';
import 'package:orginone/util/event_bus_helper.dart';
import 'package:orginone/util/hive_utils.dart';
import 'package:orginone/util/toast_utils.dart';

class HandOverNetWork{
  static createHandOver({
    required List<Fields> basic,required List<AssetsInfo> assets,bool isDraft = false,bool isEdit = false}) async{



    Map<String,dynamic> data = {
      "CREATE_USER": HiveUtils.getUser()?.person?.id,
      "CREATE_TIME": DateTime.now().toString(),
      "UPDATE_TIME": DateTime.now().toString(),
      "status": isDraft ? 0 : 1,
      "approvalDocument": {
        "SUBMITTER_NAME": HiveUtils.getUser()?.person?.name,
        "detail": assets.map((e) => e.toJson()).toList(),
        "SUBMITTER_ID": HiveUtils.getUser()?.person?.id,
      }
    };
    for (var element in basic) {
      data.addAll(element.toUploadJson());
      data['approvalDocument'].addAll(element.toUploadJson());
    }

    ResultType resultType;
    if (!isDraft) {
      List<UpdateAssetsRequest> request = assets
          .map((element) =>
              UpdateAssetsRequest(assetCode: element.assetCode!, updateData: {
                "USER_NAME": data['USER_NAME'],
                "USER": data['USER'],
                "KAPIANZT": CardStatus.handOver.toStatusId,
              }))
          .toList();
      await AssetManagement().updateAssetsForList(request);
    }

    if (isEdit) {
      resultType = await KernelApi.getInstance().anystore.update(
          "asset_restore",
          {
            "match": {
              "BILL_CODE": data['BILL_CODE'],
            },
            "update": {
              "_set_": data,
            }
          },
          "company");
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