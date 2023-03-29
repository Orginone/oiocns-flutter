


import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/target/itarget.dart';
import 'package:orginone/event/load_assets.dart';
import 'package:orginone/model/asset_creation_config.dart';
import 'package:orginone/model/assets_info.dart';
import 'package:orginone/util/asset_management.dart';
import 'package:orginone/util/department_management.dart';
import 'package:orginone/util/event_bus_helper.dart';
import 'package:orginone/util/hive_utils.dart';
import 'package:orginone/util/toast_utils.dart';
import 'package:orginone/widget/loading_dialog.dart';

class TransferNetWork{
  static createTransfer({
    required  List<Fields> basic, required List<AssetsInfo> assets,bool isDraft = false,bool isEdit = false}) async{


    Map<String,dynamic> data = {
      "SUBMITTER_NAME": HiveUtils.getUser()?.person?.name,
      "status": isDraft?0:1,
      "CREATE_TIME": DateTime.now().toString(),
      "UPDATE_TIME": DateTime.now().toString(),
      "SUBMITTER_ID": HiveUtils.getUser()?.person?.id,
      "approvalDocument": {
        "CREATE_USER": HiveUtils.getUser()?.person?.id,
        "detail": assets.map((e) => e.toJson()).toList(),
        "SUBMITTER_NAME": HiveUtils.getUser()?.person?.name,
        "SUBMITTER_ID": HiveUtils.getUser()?.person?.id,
      }
    };
    for (var element in basic) {
      data.addAll(element.toUploadJson());
      data['approvalDocument'].addAll(element.toUploadJson());
    }

    ResultType resultType;
    if(!isDraft){
      List<UpdateAssetsRequest> request = assets
          .map((element) =>
          UpdateAssetsRequest(assetCode: element.assetCode!, updateData: {
            "USER": data['KEEPER_ID'],
            "USER_NAME": data['KEEPER_NAME'],
            "USE_DEPT": data['KEEP_ORG_ID'],
            "USE_DEPT_NAME": data['KEEP_ORG_NAME'],
            "KAPIANZT":CardStatus.transfer.toStatusId,
          }))
          .toList();

      await AssetManagement().updateAssetsForList(request);
    }

    if(isEdit){
      resultType = await KernelApi.getInstance().anystore.update("asset_transfer",{
        "match":{
          "BILL_CODE":data["BILL_CODE"],
        },
        "update":{
          "_set_":data,
        }
      },"company");
    }else{
      resultType = await KernelApi.getInstance().anystore.insert("asset_transfer", data,"company");
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
