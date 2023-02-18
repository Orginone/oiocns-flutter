import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orginone/components/template/originone_scaffold.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/permission_util.dart';
import 'package:orginone/util/sys_util.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:scan/scan.dart';

class ScanningPage extends GetView<ScanningController> {
  const ScanningPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    controller.checkSetCameraAuthorized();
    SysUtil.setStatusBarBright();
    return OrginoneScaffold(
      appBarPercent: 0,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Obx(
              () => controller.cameraAuthorized.value
                  ? QRView(
                      key: GlobalKey(debugLabel: "QR"),
                      onQRViewCreated: controller.onQRViewCreated,
                    )
                  : Container(color: Colors.black),
            ),
          ),
          Positioned(
            left: 20.w,
            top: 20.h,
            child: GFIconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              padding: EdgeInsets.all(8.w),
              onPressed: () => Get.back(),
              color: Colors.white,
              shape: GFIconButtonShape.circle,
            ),
          ),
          Positioned(
            right: 60.w,
            bottom: 60.h,
            child: GFIconButton(
              onPressed: () async {
                var picker = controller.picker;
                var gallery = ImageSource.gallery;
                XFile? pickedImage = await picker.pickImage(source: gallery);
                if (pickedImage == null) {
                  Fluttertoast.showToast(msg: "请选择一张图片!");
                } else {
                  controller.toScanningResult(pickedImage);
                }
              },
              icon: const Icon(Icons.photo_camera_back_outlined),
              color: Colors.grey.withAlpha(200),
            ),
          ),
        ],
      ),
    );
  }
}

class ScanningBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ScanningController());
  }
}

enum SystemScanDataType { person, company, unknown }

class ScanResults {
  final SystemScanDataType scanResultType;
  dynamic data;

  ScanResults(this.scanResultType, this.data);
}

class ScanningController extends FullLifeCycleController
    with FullLifeCycleMixin {
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
    if (resultMap['type'] != null) {
      // ScanResults scanResults = ScanResults.fromMap(resultMap);
      // switch (scanResults.scanResultType) {
      //   case SystemScanDataType.person:
      //     // Get.offNamed(Routers.personDetail, arguments: scanResults.data);
      //     break;
      //   case SystemScanDataType.company:
      //     break;
      //   case SystemScanDataType.unknown:
      //     break;
      //   default:
      //     Get.offNamed(Routers.scanningResult, arguments: result);
      // }
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
