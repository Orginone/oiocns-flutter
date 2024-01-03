import 'package:flutter/material.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/components/widgets/gy_scaffold.dart';
import 'package:scan/scan.dart';
import 'logic.dart';
import 'state.dart';

class QrScanPage extends BaseGetView<QrScanController, QrScanState> {
  const QrScanPage({super.key});

  @override
  Widget buildView() {
    return GyScaffold(
      titleName: '扫一扫',
      backgroundColor: Colors.white,
      actions: [
        TextButton(
          child: const Text("相册"),
          onPressed: () => controller.chooseImage(),
        ),
      ],
      body: scanView,
    );
  }

  Widget get scanView => ScanView(
        controller: controller.scanController,
        scanAreaScale: .7,
        scanLineColor: Colors.green.shade400,
        onCapture: (data) => controller.scanResult(data),
      );
}
