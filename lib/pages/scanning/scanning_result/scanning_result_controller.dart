import 'dart:convert';

import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/enumeration/scan_result_type.dart';

import '../../../util/regex_util.dart';

class ScanningResultController extends GetxController {
  Logger log = Logger("ScanningResultController");

  Rx<ScanResultType> resultType = ScanResultType.unknown.obs;
  late String codeRes;
  late Map<String,dynamic> codeResMap;

  @override
  void onInit() {
    codeRes = Get.arguments;
    if (CustomRegexUtil.isWebsite(codeRes)) {
      resultType.value = ScanResultType.website;
    }
    else {
      Map<String,dynamic> result = jsonDecode(codeRes);
      //如果解析出来对象中有type,则为系统类消息
      if (result['type'] != null) {
        resultType.value = ScanResultType.system;
        codeResMap = result;
      } else {
        resultType.value = ScanResultType.unknown;
      }
    }
    super.onInit();
  }
}
