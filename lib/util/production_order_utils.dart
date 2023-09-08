import 'package:fluttertoast/fluttertoast.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/main.dart';
import 'package:orginone/util/date_utils.dart';

class ProductionOrderUtils {
  static const int _count = 0;

  static Future<String> productionSingleOrder(String type) async {
    String ymd = DateTime.now().format(format: "yyyyMMdd");
    String key = '${type}_$ymd';

    ResultType result = await kernel.anystore.get(key, "company");
    if (result.success) {
      int latestCount = (result.data["count"] ?? _count) + 1;

      ResultType result1 = await kernel.anystore.set(
          key,
          {
            "operation": "replaceAll",
            "data": {
              "count": latestCount,
            }
          },
          "company");
      if (result1.success) {
        String countStr = '$latestCount ';
        return type +
            ymd +
            '00000000'.substring(0, 8 - countStr.length) +
            countStr;
      } else {
        Fluttertoast.showToast(msg: result1.msg);
      }
    } else {
      Fluttertoast.showToast(msg: result.msg);
    }
    return "";
  }
}
