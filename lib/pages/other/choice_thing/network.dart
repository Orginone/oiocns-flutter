

import 'package:get/get.dart';
import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/model/thing_model.dart';

import '../../../dart/base/model.dart' hide ThingModel;

class ChoiceThingNetWork{

  static Future<List<ThingModel>> getThing() async{
    List<ThingModel> things = [];
    var settingCtrl = Get.find<SettingController>();
    ResultType result = await KernelApi.getInstance().anystore.loadThing({
      "searchExpr": "undefined",
      "searchOperation": 'contains',
      "searchValue": null,
      "userData": [],
      "options": {
        "match": {},
      },
    }, settingCtrl.user.id);

    if(result.success){
      result.data['data'].forEach((json){
        things.add(ThingModel.fromJson(json));
      });
    }

    return things;
  }
}