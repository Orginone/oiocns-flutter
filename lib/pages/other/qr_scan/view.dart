import 'package:flutter/material.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/widget/gy_scaffold.dart';
import 'package:scan/scan.dart';
import 'logic.dart';
import 'state.dart';

class QrScanPage extends BaseGetView<QrScanController, QrScanState> {
  QrScanPage();

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
/// 二维码扫描 旧版本  不支持相册的第三方库实现 先放着 等上面的实现稳定后再删除
/*
class QrScanPage1 extends BaseGetView<QrScanController, QrScanState> {
  @override
  Widget buildView() {
    return const GyScaffold(
      titleName: '扫一扫',
      backgroundColor: Colors.transparent,
      body: QrScan1(),
    );
  }
}

class QrScan1 extends StatefulWidget {
  const QrScan1({Key? key}) : super(key: key);

  @override
  State<QrScan1> createState() => _QrScanState1();
}

class _QrScanState1 extends State<QrScan1> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  Widget build(BuildContext context) {
    return QRView(
      key: qrKey,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.white,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: MediaQuery.of(context).size.width * 0.7,
      ),
      onQRViewCreated: _onQRViewCreated,
      onPermissionSet: (p0, p1) {
        if (!p1) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('未获取相机权限，请在设置中打开相机权限')),
          );
        }
      },
    );
  }

  @override
  void reassemble() {
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
    super.reassemble();
  }

  void _onQRViewCreated(QRViewController controller) {
    controller.resumeCamera();
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      result = scanData;
      controller.dispose();
      Log.info('扫描结果：${scanData.code}');
      Get.back(result: scanData.code);
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
*/