import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';
import 'package:orginone/api_resp/scan_results.dart';
import 'package:orginone/enumeration/system_scan_data_type.dart';
import 'package:orginone/util/permission_util.dart';
import 'package:permission_handler/permission_handler.dart';
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
    Map<String, dynamic> resultMap = jsonDecode(result ?? '');
    //如果解析出来对象中有type,则为系统类消息,有些可能是要跳转界面
    if (resultMap['type'] != null) {
      ScanResults scanResults = ScanResults.fromMap(resultMap);
      switch (scanResults.scanResultType) {
        case SystemScanDataType.person:
          Get.offNamed(Routers.personDetail, arguments: scanResults.data);
          break;
        case SystemScanDataType.company:
          break;
        case SystemScanDataType.unknown:
          break;
        default:
          Get.offNamed(Routers.scanningResult, arguments: result);
      }
    } else {
      Get.offNamed(Routers.scanningResult, arguments: result);
    }
  }

  checkSetCameraAuthorized() async {
    var hasCamera = await Permission.camera.status;
    if (hasCamera == PermissionStatus.granted) {
      cameraAuthorized.value = true;
    } else {
      PermissionUtil.showPermissionDialog(context!, Permission.camera);
    }
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
