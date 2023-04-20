import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/widget/template/originone_scaffold.dart';
import 'package:orginone/widget/unified.dart';
import 'package:orginone/util/regex_util.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ScanningResultPage extends GetView<ScanningResultController> {
  const ScanningResultPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late Widget body = Obx(() {
      switch (controller.resultType.value) {
        case ScanResultType.website:
          return WebView(initialUrl: controller.codeRes);
        case ScanResultType.system:
          return Container();
        case ScanResultType.unknown:
          return Text(controller.codeRes);
      }
    });

    return OrginoneScaffold(
      appBarLeading: XWidgets.defaultBackBtn,
      appBarTitle: Text("扫描结果", style: XFonts.size22Black3),
      appBarCenterTitle: true,
      body: body,
    );
  }
}

enum ScanResultType { website, system, unknown }

class ScanningResultBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ScanningResultController());
  }
}

class ScanningResultController extends GetxController {
  Rx<ScanResultType> resultType = ScanResultType.unknown.obs;
  late String codeRes;
  late Map<String, dynamic> codeResMap;

  @override
  void onInit() {
    codeRes = Get.arguments;
    if (CustomRegexUtil.isWebsite(codeRes)) {
      resultType.value = ScanResultType.website;
    } else {
      Map<String, dynamic> result = jsonDecode(codeRes);
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
