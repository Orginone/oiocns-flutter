import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/util/date_utils.dart';

class ProductionOrderUtils {
  static const int _count = 0;

  static Future<String> productionSingleOrder(String type) async {
    String ymd = DateTime.now().format(format: "yyyyMMDD");
    String key = '${type}_$ymd';

    ResultType result =
        await KernelApi.getInstance().anystore.get(key, "company");
    if (result.success) {
      int latestCount = _count + 1;

      ResultType result = await KernelApi.getInstance().anystore.set(
          key,
          {
            "operation": "replaceAll",
            "data": {
              "count": latestCount,
            }
          },
          "company");
      if(result.success){
        String countStr = '$latestCount ';
        return type + ymd + '00000000'.substring(0, 8 - countStr.length) + countStr;
      }
    }
    return "";
  }
}
