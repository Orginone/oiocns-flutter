


import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/target/itarget.dart';
import 'package:orginone/model/my_assets_list.dart';
import 'package:orginone/util/department_utils.dart';
import 'package:orginone/util/hive_utils.dart';

class TransferNetWork{
  static createTransfer({
    required String billCode,required String keeperId,required String keepOrgId,required String remark
,required List<MyAssetsList> assets,bool isDraft = false}) async{
    await KernelApi.getInstance().anystore.insert("asset_transfer", {
      "BILL_CODE":billCode,
      "KEEPER_ID":keeperId,
      "KEEP_ORG_ID":keepOrgId,
      "OLD_ORG_NAME":DepartmentUtils().currentDepartment?.name,
      "OLD_ORG_ID":DepartmentUtils().currentDepartment?.name,
      "OLD_USER_ID":HiveUtils.getUser()?.person?.name,
      "APPLY_REMARK":remark,
      "approvalDocument": {
        "OLD_USER_ID": HiveUtils.getUser()?.person?.name,
        "KEEPER_ID": keeperId,
        "KEEP_ORG_ID": keepOrgId,
        "OLD_ORG_ID": DepartmentUtils().currentDepartment?.name,
        "OLD_ORG_NAME": DepartmentUtils().currentDepartment?.name,
        "detail": assets.map((e) => e.toJson()).toList(),
        "status": "1",
        "CREATE_USER": HiveUtils.getUser()?.person?.id,
        "submitUserName": HiveUtils.getUser()?.person?.name,
        "CREATE_TIME": DateTime.now().toString(),
        "UPDATE_TIME": DateTime.now().toString(),
      }
    }, isDraft?"user":"company");
  }

}