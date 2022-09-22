import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/component/unified_scaffold.dart';
import 'package:orginone/page/scanning/scanning_controller.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../component/unified_text_style.dart';
import '../../util/widget_util.dart';

class ScanningPage extends GetView<ScanningController> {
  const ScanningPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UnifiedScaffold(
      appBarLeading: WidgetUtil.defaultBackBtn,
      appBarTitle: Text("扫一扫", style: text20),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: GlobalKey(debugLabel: "QR"),
              onQRViewCreated: controller.onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (controller.result != null)
                  ? Text('Barcode Type: ${controller.result!.format}  '
                      ' Data: ${controller.result!.code}')
                  : const Text('Scan a code'),
            ),
          )
        ],
      ),
    );
  }
}
