


import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/target/itarget.dart';
import 'package:orginone/event/load_assets.dart';
import 'package:orginone/model/assets_info.dart';
import 'package:orginone/util/asset_management.dart';
import 'package:orginone/util/department_management.dart';
import 'package:orginone/util/event_bus_helper.dart';
import 'package:orginone/util/hive_utils.dart';
import 'package:orginone/util/toast_utils.dart';
import 'package:orginone/widget/loading_dialog.dart';

class TransferNetWork{
  static createTransfer({
    required String billCode, XTarget? keeper, ITarget? keepOrg,required String remark
,required List<AssetsInfo> assets,bool isDraft = false,bool isEdit = false}) async{


    Map<String,dynamic> data = {
      "BILL_CODE":billCode,
      "KEEPER_ID":keeper?.name,
      "KEEP_ORG_ID":keepOrg?.name,
      "OLD_ORG_NAME":DepartmentManagement().currentDepartment?.name,
      "OLD_ORG_ID":DepartmentManagement().currentDepartment?.name,
      "OLD_USER_ID":HiveUtils.getUser()?.person?.name,
      "SUBMITTER_NAME": HiveUtils.getUser()?.person?.name,
      "APPLY_REMARK":remark,
      "status": isDraft?0:1,
      "CREATE_TIME": DateTime.now().toString(),
      "UPDATE_TIME": DateTime.now().toString(),
      "approvalDocument": {
        "OLD_USER_ID": HiveUtils.getUser()?.person?.name,
        "KEEPER_ID": keeper?.name,
        "KEEP_ORG_ID": keepOrg?.name,
        "CREATE_USER": HiveUtils.getUser()?.person?.id,
        "OLD_ORG_ID": DepartmentManagement().currentDepartment?.name,
        "OLD_ORG_NAME": DepartmentManagement().currentDepartment?.name,
        "detail": assets.map((e) => e.toJson()).toList(),
        "SUBMITTER_NAME": HiveUtils.getUser()?.person?.name,
      }
    };

    ResultType resultType;
    if(!isDraft){
      List<UpdateAssetsRequest> request = assets
          .map((element) =>
          UpdateAssetsRequest(assetCode: element.assetCode!, updateData: {
            "USER": keeper?.id,
            "USER_NAME": keeper?.name,
            "USE_DEPT": keepOrg?.id,
            "USE_DEPT_NAME": keepOrg?.name,
            "KAPIANZT":CardStatus.transfer.toStatusId,
          }))
          .toList();

      await AssetManagement().updateAssetsForList(request);
    }

    if(isEdit){
      resultType = await KernelApi.getInstance().anystore.update("asset_transfer",{
        "match":{
          "BILL_CODE":billCode,
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