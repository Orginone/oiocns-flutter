import 'package:orginone/main_bean.dart';
import '../../../dart/base/model.dart' hide ThingModel;

class ChoiceThingNetWork {
  static Future<List<AnyThingModel>> getThing(String id, String belongId,
      {String? filter, int index = 0}) async {
    List<AnyThingModel> things = [];
    ResultType result = await kernel.loadThing(
      belongId,
      [],
      {
        "requireTotalCount": true,
        "searchOperation": "contains",
        "searchValue": null,
        "skip": index * 20,
        "take": 20,
        "userData": filter != null ? [filter] : [],
        "sort": [
          {"selector": "Id", "desc": false}
        ],
        "group": null
      },
    );

    if (result.success) {
      result.data['data'].forEach((json) {
        things.add(AnyThingModel.fromJson(json));
      });
    }

    return things;
  }
}
