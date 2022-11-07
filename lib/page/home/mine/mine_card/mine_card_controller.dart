import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:logging/logging.dart';
import 'package:orginone/api_resp/target_resp.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../logic/authority.dart';

class MineCardController extends GetxController {
  final Logger log = Logger("MineCardController");
  TargetResp userInfo = auth.userInfo;
  GlobalKey globalKey1 = GlobalKey();
  //截图后的文件路径，通过File包装并通过.image可以展示出来
  String captureImgPath = '';
  @override
  void onReady() async {
    super.onReady();
  }
  /// 截屏图片生成图片流ByteData
  void captureImage() async {
    RenderRepaintBoundary? boundary = globalKey1.currentContext!
        .findRenderObject() as RenderRepaintBoundary?;
    double dpr = ui.window.devicePixelRatio; // 获取当前设备的像素比
    var image = await boundary!.toImage(pixelRatio: dpr);
    // 将image转化成byte
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);

    var filePath = "";

    Uint8List pngBytes = byteData!.buffer.asUint8List();
    // 获取手机存储（getTemporaryDirectory临时存储路径）
    Directory applicationDir = await getTemporaryDirectory();
    // getApplicationDocumentsDirectory();
    // 判断路径是否存在
    bool isDirExist = await Directory(applicationDir.path).exists();
    if (!isDirExist) Directory(applicationDir.path).create();
    // 直接保存，返回的就是保存后的文件
    File saveFile = await File(
        applicationDir.path + "${DateTime.now().toIso8601String()}.jpg")
        .writeAsBytes(pngBytes);
    filePath = saveFile.path;
    captureImgPath = filePath;
    update();
  }
}
