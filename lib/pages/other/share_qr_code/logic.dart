import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/controller/index.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/main.dart';
import 'package:orginone/pages/chat/message_forward.dart';
import 'package:orginone/util/toast_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:ui' as ui;
import 'state.dart';

class ShareQrCodeController extends BaseController<ShareQrCodeState> {
  @override
  final ShareQrCodeState state = ShareQrCodeState();
  final GlobalKey globalKey = GlobalKey();
  scan() {
    // Log.info('扫描');
    IndexController c = Get.find<IndexController>();
    c.qrScan();
  }

  share() async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? byteData =
        await (image.toByteData(format: ui.ImageByteFormat.png));

    if (byteData != null) {
      // 将 ByteData 转换为 Uint8List
      final uint8List = byteData.buffer.asUint8List();
      var file = await saveImage(uint8List);
      var docDir = settingCtrl.user.directory;
      var item = await docDir.createFile(
        File(file.path),
        progress: (progress) {},
      );

      if (item != null) {
        showModalBottomSheet(
            context: Get.context!,
            builder: (context) {
              return MessageForward(
                msgBody: MsgBodyModel.fromJson(item.shareInfo().toJson()),
                msgType: MessageType.image.label,
                onSuccess: () {
                  Navigator.pop(context);
                },
              );
            },
            isScrollControlled: true,
            isDismissible: false,
            useSafeArea: true,
            barrierColor: Colors.white);
      }
    }
  }

  save() async {
    // Log.info('保存');

    bool req = await requestPermission();
    if (req) {
      saveAssetsImg();
    }
  }

  // 动态申请权限，ios 要在info.plist 上面添加
  // / 动态申请权限，需要区分android和ios，很多时候它两配置权限时各自的名称不同
  // / 此处以保存图片需要的配置为例
  Future<bool> requestPermission() async {
    // 1、读取系统权限的弹框
    PermissionStatus storageStatus = await Permission.storage.status;
    if (storageStatus != PermissionStatus.granted) {
      if (Platform.isIOS) {
        storageStatus = await Permission.photosAddOnly.request();
      } else {
        storageStatus = await Permission.storage.request();
        // Log.info('storageStatus: $storageStatus');
        // storageStatus = await Permission.manageExternalStorage.request();
      }
    }

    // 2、假如你点not allow后，下次点击不会在出现系统权限的弹框（系统权限的弹框只会出现一次），
    // 这时候需要你自己写一个弹框，然后去打开app权限的页面
    if (storageStatus != PermissionStatus.granted) {
      showCupertinoDialog(
          context: Get.context!,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text('需要给相册授权'),
              content: const Text('请到您的手机设置打开相册访问权限'),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: const Text('取消'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                CupertinoDialogAction(
                  child: const Text('去设置'),
                  onPressed: () {
                    Navigator.pop(context);
                    // 打开手机上该app权限的页面
                    openAppSettings();
                  },
                ),
              ],
            );
          });
      return false;
    } else {
      return true;
    }
  }

// 保存APP里的图片

  saveAssetsImg() async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? byteData =
        await (image.toByteData(format: ui.ImageByteFormat.png));
    if (byteData != null) {
      final result =
          await ImageGallerySaver.saveImage(byteData.buffer.asUint8List());
      if (result['isSuccess']) {
        ToastUtils.showMsg(msg: "保存图片成功");
      } else {
        ToastUtils.showMsg(msg: "保存失败");
      }
    }
  }

  //将回调拿到的Uint8List格式的图片转换为File格式
  saveImage(Uint8List imageByte) async {
    //获取临时目录
    var tempDir = await getTemporaryDirectory();
    //生成file文件格式
    var file =
        await File('${tempDir.path}/image_${DateTime.now().millisecond}.jpg')
            .create();
    //转成file文件
    file.writeAsBytesSync(imageByte);
    return file;
  }
}
