import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/widget/gy_scaffold.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'logic.dart';
import 'state.dart';

class QrScanPage extends BaseGetView<QrScanController,QrScanState>{
  @override
  Widget buildView() {
    return  const GyScaffold(
      titleName: '扫一扫',
      backgroundColor: Colors.transparent,
      body:QrScan(),
    );
  }
}

class QrScan extends StatefulWidget {

  const QrScan({Key? key}) : super(key: key);

  @override
  State<QrScan> createState() => _QrScanState();
}

class _QrScanState extends State<QrScan> {

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  Widget build(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
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
      Get.back(result: scanData.code);
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
