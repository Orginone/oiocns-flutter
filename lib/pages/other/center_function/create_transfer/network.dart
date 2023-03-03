


import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/event/load_assets.dart';
import 'package:orginone/model/my_assets_list.dart';
import 'package:orginone/util/asset_management.dart';
import 'package:orginone/util/department_management.dart';
import 'package:orginone/util/event_bus_helper.dart';
import 'package:orginone/util/hive_utils.dart';
import 'package:orginone/util/toast_utils.dart';

class TransferNetWork{
  static createTransfer({
    required String billCode,required String keeperId,required String keepOrgId,required String remark
,required List<MyAssetsList> assets,bool isDraft = false}) async{

    Map<String, dynamic> user = {"value": keeperId};
    Map<String, dynamic> dept = {"value": keepOrgId};
    List<UpdateAssetsRequest> request = assets
        .map((element) =>
        UpdateAssetsRequest(assetCode: element.assetCode!, updateData: {
          "USER": user,
          "USE_DEPT": dept,
          "KAPIANZT":"08",
        }))
        .toList();

    await AssetManagement().updateAssetsForList(request);

    ResultType resultType =   await KernelApi.getInstance().anystore.insert("asset_transfer", {
      "BILL_CODE":billCode,
      "KEEPER_ID":keeperId,
      "KEEP_ORG_ID":keepOrgId,
      "OLD_ORG_NAME":DepartmentManagement().currentDepartment?.name,
      "OLD_ORG_ID":DepartmentManagement().currentDepartment?.name,
      "OLD_USER_ID":HiveUtils.getUser()?.person?.name,
      "APPLY_REMARK":remark,
      "status": isDraft?0:1,
      "CREATE_TIME": DateTime.now().toString(),
      "UPDATE_TIME": DateTime.now().toString(),
      "approvalDocument": {
        "OLD_USER_ID": HiveUtils.getUser()?.person?.name,
        "KEEPER_ID": keeperId,
        "KEEP_ORG_ID": keepOrgId,
        "CREATE_USER": HiveUtils.getUser()?.person?.id,
        "OLD_ORG_ID": DepartmentManagement().currentDepartment?.name,
        "OLD_ORG_NAME": DepartmentManagement().currentDepartment?.name,
        "detail": assets.map((e) => e.toJson()).toList(),
        "submitUserName": HiveUtils.getUser()?.person?.name,
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