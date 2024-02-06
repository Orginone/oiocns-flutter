import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/main_base.dart';

class UseTracesNetWork {
  static Future<XThingArchives?> getThingArchives(String id) async {
    //TODO:IForm没有这个loadThingArchives  用到时候要研究一下逻辑
    // ResultType result = await kernel.loadThingArchives({
    //   "options": {
    //     "match": {
    //       "_id": {
    //         "_eq_": id,
    //       },
    //     },
    //   },
    //   "userData": [],
    // }, relationCtrl.user.metadata.id);
    ResultType result = await kernel.loadThing(
      relationCtrl.user.metadata.id,
      [],
      {
        "options": {
          "match": {
            "_id": {
              "_eq_": id,
            },
          },
        },
        "userData": [],
      },
    );
    if (result.success) {
      return XThingArchives.fromJson(result.data['data'][0]);
    }
    return null;
  }
}
