


import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/model/asset_use.dart';
import 'package:orginone/model/my_assets_list.dart';
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
    }
    return use;
  }

  static Future<MyAssetsList?> getQrScanData() async{
    MyAssetsList? qrScanData;

   ResultType result = await KernelApi.getInstance().anystore.aggregate(
        "assets_data",
        {
          "match": {
            "ASSET_CODE":"ZCGL2023022800000042",
          },
          "sort": {"UPDATE_TIME": -1},
          "skip": 0,
          "limit": 9999,
        },
        "company"
    );
   if(result.success){
      if(result.data.isNotEmpty){
        var data = MyAssetsList.fromJson(result.data.first);
        if(data.user?['value'] != HiveUtils.getUser()?.userName){
          ToastUtils.showMsg(msg: "这个二维码的使用人并非当前登录用户");
        }else{
          qrScanData = data;
        }
      }
   }else{
     ToastUtils.showMsg(msg: "获取内容失败");
   }

    return qrScanData;
  }

}