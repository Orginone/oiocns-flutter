


import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/model/asset_use.dart';

class AssetNetWork{

  static Future<List<AssetUse>> getAssetUseList({int status = 0,required String name}) async{
    List<AssetUse> use = [];
    ResultType result = await KernelApi.getInstance().anystore.aggregate(name, {
      "match": {
        "status":status
      },
      "sort": {"UPDATE_TIME": -1},
      "skip": 0,
      "limit": 9999,
    }, status == 0?"user":"company");

    if(result.success){
      result.data.forEach((json){
        use.add(AssetUse.fromJson(json));
      });
    }
    return use;
  }

}