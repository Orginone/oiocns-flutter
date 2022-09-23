import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';
import 'package:orginone/util/permission_util.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:scan/scan.dart';

import '../../routers.dart';

class ScanningController extends FullLifeCycleController
    with FullLifeCycleMixin {
  Logger log = Logger("ScanningController");

  ImagePicker picker = ImagePicker();
  BuildContext? context;
  RxBool cameraAuthorized = false.obs;

  onQRViewCreated(QRViewController qrController) {
    qrController.scannedDataStream.listen((scanRes) {
      Get.offNamed(Routers.scanningResult, arguments: scanRes.code);
    });
  }

  toScanningResult(XFile file) async {
    String? result = await Scan.parse(file.path);
    Get.offNamed(Routers.scanningResult, arguments: result);
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
