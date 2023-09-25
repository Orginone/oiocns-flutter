import 'package:orginone/dart/base/api/kernelapi_old.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/main.dart';

class UseTracesNetWork {
  static Future<XThingArchives?> getThingArchives(String id) async {
    ResultType result = await kernel.anystore.loadThingArchives({
      "options": {
        "match": {
          "_id": {
            "_eq_": id,
          },
        },
      },
      "userData": [],
    }, settingCtrl.user.metadata.id!);
    if (result.success) {
      return XThingArchives.fromJson(result.data['data'][0]);
    }
    return null;
  }
}
