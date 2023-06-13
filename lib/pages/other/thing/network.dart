

import 'package:get/get.dart';
import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/main.dart';
import 'package:orginone/model/thing_model.dart';

import '../../../dart/base/model.dart' hide ThingModel;

class ThingNetWork{

  static Future<List<ThingModel>> getThing(String id) async{
    List<ThingModel> things = [];
    ResultType result = await KernelApi.getInstance().anystore.loadThing({
      "searchExpr": "undefined",
      "searchOperation": 'contains',
      "searchValue": null,
      "userData": [
        "S$id"
      ],
      "options": {
        "match": {},
      },
    }, settingCtrl.user.metadata.id);

    if(result.success){
      result.data['data'].forEach((json){
        things.add(ThingModel.fromJson(json));
      });
    }

    return things;
  }
}