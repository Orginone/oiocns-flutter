import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/util/permission_util.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanningController extends FullLifeCycleController
    with FullLifeCycleMixin {
  Logger log = Logger("ScanningController");

  RxBool cameraAuthorized = false.obs;
  Barcode? result;
  QRViewController? qrController;
  BuildContext? context;

  onQRViewCreated(QRViewController qrController) {
    qrController = qrController;
    qrController.scannedDataStream.listen((scanData) {
      result = scanData;
      update();
    });
  }

  checkSetCameraAuthorized() {
    PermissionUtil.hasCamera().then((res) {
      if (res) {
        cameraAuthorized.value = true;
      } else {
        PermissionUtil.showConfirmDialog(context!);
      }
    });
  }

  @override
  onResumed() async {
    checkSetCameraAuthorized();
  }

  @override
  void onDetached() {}

  @override
  void onInactive() {}

  @override
  void onPaused() {}
}
