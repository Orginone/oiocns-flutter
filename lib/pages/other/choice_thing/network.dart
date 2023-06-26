

import 'package:get/get.dart';
import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/main.dart';
import 'package:orginone/model/thing_model.dart';

import '../../../dart/base/model.dart' hide ThingModel;

class ChoiceThingNetWork{

  static Future<List<ThingModel>> getThing(String id,String belongId) async{
    List<ThingModel> things = [];
    ResultType result = await kernel.anystore.loadThing({
      "searchExpr": "undefined",
      "searchOperation": 'contains',
      'requireTotalCount':true,
      "searchValue": null,
      "userData": [
        id
      ],
      "options": {
        "match": {},
      },
    },belongId);

    if(result.success){
      result.data['data'].forEach((json){
        things.add(ThingModel.fromJson(json));
      });
    }

    return things;
  }
}