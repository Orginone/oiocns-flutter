import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/progress_bar/gf_progress_bar.dart';
import 'package:getwidget/types/gf_progress_type.dart';
import 'package:orginone/component/unified_edge_insets.dart';
import 'package:orginone/public/image/load_image.dart';
import 'package:ota_update/ota_update.dart';

import '../util/sys_util.dart';
import 'a_font.dart';

class ConfirmStatus {
  RxBool startDownloading = false.obs;
  Rx<OtaStatus> otaStatus = OtaStatus.DOWNLOADING.obs;
  RxInt progress = 0.obs;

  ConfirmStatus();
}

class UpdaterDialog extends Dialog {
  UpdaterDialog({
    required this.icon,
    required this.version,
    required this.path,
    required this.content,
    Key? key,
  }) : super(key: key);

  final String icon;
  final String version;
  final String path;
  final String content;
  final ConfirmStatus confirmStatus = ConfirmStatus();

  @override
  Widget build(BuildContext context) {
    debugPrint("path====$icon");
    return Center(
      child: Material(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10.w)),
            boxShadow: const [
              //阴影效果
              BoxShadow(
                offset: Offset(0, 0), //阴影在X轴和Y轴上的偏移
                color: Colors.grey, //阴影颜色
                blurRadius: 3.0, //阴影程度
                spreadRadius: 0, //阴影扩散的程度 取值可以正数,也可以是负数
              ),
            ],
          ),
          width: 350.w,
          height: 400.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(padding: EdgeInsets.only(top: 20.h)),
              AImage.netImageRadiusAll(url: icon,radius: 5,size: Size(60.w, 60.w)),
              Padding(padding: EdgeInsets.only(top: 20.h)),
              description,
              progressWidget,
            ],
          ),
        ),
      ),
    );
  }

  get progressWidget => Container(
        margin: EdgeInsets.only(bottom: 10.h),
        child: Obx(() {
          if (confirmStatus.startDownloading.value) {
            switch (confirmStatus.otaStatus.value) {
              case OtaStatus.DOWNLOADING:
                return progressBar;
              case OtaStatus.INSTALLING:
                return const Text("正在安装中!");
              case OtaStatus.ALREADY_RUNNING_ERROR:
                return const Text("下载服务已运行!");
              case OtaStatus.PERMISSION_NOT_GRANTED_ERROR:
                return const Text("未授权相关权限!");
              case OtaStatus.INTERNAL_ERROR:
                return const Text("工具包服务异常!");
              case OtaStatus.DOWNLOAD_ERROR:
                return const Text("apk 包下载异常，请稍后再试!");
              case OtaStatus.CHECKSUM_ERROR:
                return const Text("apk 文件校验异常!");
            }
          } else {
            return confirmBtn;
          }
        }),
      );

  get image => Align(
        alignment: Alignment.topCenter,
        child: Image(
          width: 70.w,
          image: const AssetImage("images/logo.png"),
        ),
      );

  get description => Expanded(
        child: ListView(
          shrinkWrap: true,
          children: [
            Text(
              "发现新版本 v$version",
              style: AFont.instance.size20Black6,
              textAlign: TextAlign.center,
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 10.h,left: 15.w,right: 15.w),
              child: Text(
                content,
                style: AFont.instance.size22Black3W500,
              ),
            ),
          ],
        ),
      );

  get confirmBtn => ElevatedButton(
        onPressed: () {
          _downloadPackage();
        },
        style: ButtonStyle(padding: MaterialStateProperty.all(lr40)),
        child: const Text("立即更新"),
      );

  get progressBar => SizedBox(
      height: 20.h,
      width: 180.w,
      child: GFProgressBar(
        percentage: confirmStatus.progress.value * 1.0 / 100,
        lineHeight: 20.h,
        radius: 50.w,
        type: GFProgressType.linear,
        backgroundColor: Colors.black26,
        progressBarColor: Colors.lightGreen,
      ));

  void _downloadPackage() {
    SysUtil.update(path, (OtaEvent event) {
      OtaStatus status = event.status;
      String? value = event.value;

      confirmStatus.otaStatus.value = status;
      switch (status) {
        case OtaStatus.DOWNLOADING:
          confirmStatus.startDownloading.value = true;
          confirmStatus.progress.value = int.parse(value ?? "0");
          break;
        default:
          break;
      }
    });
  }
}
