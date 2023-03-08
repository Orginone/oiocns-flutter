


import 'package:get/get_connect/http/src/request/request.dart';
import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/model/assets_detail_config.dart';

class AssetsDetailsNetWork{
  static Future<AssetsDetailConfig> getConfig({required String belongName}) async{
    AssetsDetailConfig config;

    ResultType resultType =  await KernelApi.getInstance()
        .anystore
        .aggregate(
        "card_temp",
        {
          "match": {
            "belongName":belongName
          },
          "sort": {"UPDATE_TIME": -1},
          "skip": 0,
          "limit": 9999,
        },
        "company");
    if(resultType.success && resultType.data.isNotEmpty){
      config = AssetsDetailConfig.fromJson(resultType.data.first);
      if(config.list==null || (config.list?.isEmpty??true)){
        config = AssetsDetailConfig.fromJson(defaultConfig);
      }
    }else{
      config = AssetsDetailConfig.fromJson(defaultConfig);
    }

    return config;
  }
}