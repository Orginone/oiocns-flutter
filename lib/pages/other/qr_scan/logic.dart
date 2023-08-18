import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:orginone/util/permission_util.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scan/scan.dart';

import 'state.dart';

class QrScanController extends BaseController<QrScanState> {
  final QrScanState state = QrScanState();
  final ImagePicker picker = ImagePicker();
  ScanController scanController = ScanController();

  @override
  onInit() {
    super.onInit();
    // requestPermission();
  }

  requestPermission() async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      PermissionUtil.showPermissionDialog(Get.context!, Permission.camera);
    }
  }

  chooseImage() async {
    try {
      var gallery = ImageSource.gallery;
      XFile? pickedImage = await picker.pickImage(source: gallery);
      if (pickedImage != null) {
        String? str = await Scan.parse(pickedImage.path);
        if (str != null) {
          state.qrcode.value = str;
          Get.back(result: str);
        } else {
          Get.snackbar('提示', '未识别到二维码');
        }
      }
    } on PlatformException catch (error) {
      if (error.code == "camera_access_denied") {
        PermissionUtil.showPermissionDialog(context, Permission.photos);
      }
    } catch (error) {
      error.printError();
      Get.snackbar('提示', "打开相册时发生异常!");
    }
  }

  scanResult(String data) {
    state.qrcode.value = data;
    Get.back(result: data);
  }
}
