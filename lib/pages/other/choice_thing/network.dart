

import 'package:get/get.dart';
import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/main.dart';
import 'package:orginone/model/thing_model.dart';

import '../../../dart/base/model.dart' hide ThingModel;

class ChoiceThingNetWork{

  static Future<List<AnyThingModel>> getThing(String id,String belongId,{int index = 0}) async{
    List<AnyThingModel> things = [];
    ResultType result = await kernel.anystore.loadThing({
      "requireTotalCount": true,
      "searchOperation": "contains",
      "searchValue": null,
      "skip": index * 20,
      "take": 20,
      "userData": [],
      "sort": [
        {
          "selector": "Id",
          "desc": false
        }
      ],
      "group": null
    },belongId);

    if(result.success){
      result.data['data'].forEach((json){
        things.add(AnyThingModel.fromJson(json));
      });
    }

    return things;
  }
}