


import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/model/asset_use.dart';
import 'package:orginone/model/assets_info.dart';
import 'package:orginone/util/hive_utils.dart';
import 'package:orginone/util/toast_utils.dart';

class AssetNetWork{

  static Future<List<AssetUse>> getAssetUseList({required String name,Map<String,dynamic>? filter}) async{
    List<AssetUse> use = [];
    ResultType result = await KernelApi.getInstance().anystore.aggregate(name, {
      "match": {
       ...?filter,
      },
      "sort": {"UPDATE_TIME": -1},
      "skip": 0,
      "limit": 9999,
    },"company");
    if(result.success){
      result.data.forEach((json){
        use.add(AssetUse.fromJson(json));
      });
    }else{
      ToastUtils.showMsg(msg: "获取内容失败:${result.msg}");
    }
    return use;
  }

  static Future<AssetsInfo?> getQrScanData(String code) async{
    AssetsInfo? qrScanData;

   ResultType result = await KernelApi.getInstance().anystore.aggregate(
        "assets_data",
        {
          "match": {
            "ASSET_CODE":code,
          },
          "sort": {"UPDATE_TIME": -1},
          "skip": 0,
          "limit": 9999,
        },
        "company"
    );
   if(result.success){
      if(result.data.isNotEmpty){
        var data = AssetsInfo.fromJson(result.data.first);
        qrScanData = data;
        // if(data.userName != HiveUtils.getUser()?.userName){
        //   ToastUtils.showMsg(msg: "这个二维码的使用人并非当前登录用户");
        // }else{
        //   qrScanData = data;
        // }
      }
   }else{
     ToastUtils.showMsg(msg: "获取内容失败:${result.msg}");
   }

    return qrScanData;
  }

}