import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orginone/components/unified_edge_insets.dart';
import 'package:orginone/components/unified_scaffold.dart';
import 'package:orginone/pages/other/scanning/scanning_controller.dart';
import 'package:orginone/util/sys_util.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanningPage extends GetView<ScanningController> {
  const ScanningPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    controller.checkSetCameraAuthorized();
    SysUtil.setStatusBarBright();
    return UnifiedScaffold(
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
              padding: all5,
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
