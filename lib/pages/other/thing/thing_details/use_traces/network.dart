import 'package:get/get.dart';
import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';

class UseTracesNetWork {
  static Future<XThingArchives?> getThingArchives(String id) async {
    SettingController setting = Get.find<SettingController>();
    ResultType result = await KernelApi.getInstance().anystore.loadThingArchives( {
        "options": {
        "match": {
          "_id": {
            "_eq_":id,
          },
        },
      },
      "userData": [],
    },setting.user.id);
    if(result.success){
      return XThingArchives.fromJson(result.data['data'][0]);
    }
    return null;
  }
}
