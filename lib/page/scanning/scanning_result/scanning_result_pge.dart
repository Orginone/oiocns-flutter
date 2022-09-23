import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/component/unified_scaffold.dart';
import 'package:orginone/page/scanning/scanning_result/scanning_result_controller.dart';
import 'package:orginone/util/widget_util.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../component/unified_text_style.dart';
import '../../../enumeration/scan_result_type.dart';

class ScanningResultPage extends GetView<ScanningResultController> {
  const ScanningResultPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late Widget body = Obx(() {
      switch (controller.resultType.value) {
        case ScanResultType.website:
          return WebView(initialUrl: controller.codeRes);
        case ScanResultType.system:
        case ScanResultType.unknown:
          return Text(controller.codeRes);
      }
    });

    return UnifiedScaffold(
      appBarLeading: WidgetUtil.defaultBackBtn,
      appBarTitle: Text("扫描结果", style: text20),
      appBarCenterTitle: true,
      body: body,
    );
  }
}
