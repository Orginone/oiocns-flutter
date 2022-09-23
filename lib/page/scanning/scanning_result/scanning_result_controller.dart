import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/enumeration/scan_result_type.dart';

import '../../../util/regex_util.dart';

class ScanningResultController extends GetxController {
  Logger log = Logger("ScanningResultController");

  Rx<ScanResultType> resultType = ScanResultType.unknown.obs;
  late String codeRes;

  @override
  void onInit() {
    codeRes = Get.arguments;
    if (CustomRegexUtil.isWebsite(codeRes)) {
      resultType.value = ScanResultType.website;
    } else {
      resultType.value = ScanResultType.unknown;
    }
    super.onInit();
  }
}
