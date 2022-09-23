import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/enumeration/scan_result_type.dart';

import '../../../util/regex_util.dart';

class ScanningResultController extends GetxController {
  Logger log = Logger("ScanningResultController");

  late ScanResultType resultType;
  late String codeRes;

  @override
  void onInit() {
    codeRes = Get.arguments;
    if (CustomRegexUtil.isWebsite(codeRes)) {
      resultType = ScanResultType.website;
    } else {
      resultType = ScanResultType.unknown;
    }
    super.onInit();
  }
}
