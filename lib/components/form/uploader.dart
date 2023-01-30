import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/getwidget.dart';
import 'package:orginone/components/unified_colors.dart';

import '../../core/base/api/bucket_api.dart';
import '../a_font.dart';

class Uploader extends StatelessWidget {
  final double progress;
  final String? errorText;
  final Function? uploadedCall;

  const Uploader({
    Key? key,
    required this.progress,
    this.errorText,
    this.uploadedCall,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(padding: EdgeInsets.only(top: 20.h)),
        GFProgressBar(
          percentage: progress,
          width: 100.w,
          lineHeight: 20.h,
          radius: 50.w,
          type: GFProgressType.linear,
          backgroundColor: Colors.black26,
          progressBarColor: Colors.lightGreen,
          alignment: MainAxisAlignment.center,
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
              progressCallback: (value) {
                if (uploadedCall != null) {
                  uploadedCall!(value, name);
                }
              },
            );
          },
          child: Text("上传文件", style: AFont.instance.size22WhiteW500),
        ),
        if (errorText != null)
          Text(errorText!,
              style: TextStyle(
                color: UnifiedColors.fontErrorColor,
                fontSize: 18.sp,
              ))
      ],
    );
  }
}
