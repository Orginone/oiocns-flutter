import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';

import '../../api/bucket_api.dart';
import '../a_font.dart';

class Uploader extends StatelessWidget {
  final RxDouble progress;

  const Uploader({
    Key? key,
    required this.progress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Obx(
          () => GFProgressBar(
            percentage: progress.value,
            width: 100.w,
            lineHeight: 20.h,
            radius: 50.w,
            type: GFProgressType.linear,
            backgroundColor: Colors.black26,
            progressBarColor: Colors.lightGreen,
            alignment: MainAxisAlignment.center,
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            var picker = FilePicker.platform;
            var result = await picker.pickFiles(
              type: FileType.custom,
              allowedExtensions: ["apk"],
            );
            if (result == null) {
              return;
            }
            if (result.paths.length != 1 || result.names.length != 1) {
              Fluttertoast.showToast(msg: "请选择一个 APK 文件！");
              return;
            }
            var name = result.names[0];
            var path = result.paths[0];
            if (name == null || path == null) {
              Fluttertoast.showToast(msg: "未获取到文件路径！");
              return;
            }

            BucketApi.uploadChunk(
              prefix: "",
              filePath: path,
              fileName: name,
              shareDomain: "all",
              progressCallback: (progress) {
                progress.value = progress;
              },
            );
          },
          child: Text("上传文件", style: AFont.instance.size22WhiteW500),
        ),
      ],
    );
  }
}
