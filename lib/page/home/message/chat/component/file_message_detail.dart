import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/component/unified_text_style.dart';
import 'package:orginone/controller/message/message_controller.dart';

class FileMessageDetail extends StatelessWidget {
  final FileDetail detail;

  const FileMessageDetail(this.detail, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5.w)),
      ),
      padding: EdgeInsets.all(10.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Text(
                detail.fileName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: text16,
              ),
              Text(
                detail.size,
              ),
            ],
          ),
          _fileIcon(detail)
        ],
      ),
    );
  }

  Widget _fileIcon(FileDetail detail) {
    return Obx(() {
      FileStatus status = detail.status.value;
      Icon fileIcon = Icon(Icons.file_present, size: 40.w);
      switch (status) {
        case FileStatus.local:
        case FileStatus.uploaded:
        case FileStatus.synced:
          return fileIcon;
        case FileStatus.uploading:
        case FileStatus.pausing:
          return SizedBox(
            width: 40.w,
            height: 40.w,
            child: Stack(
              alignment: Alignment.center,
              children: [
                fileIcon,
                status == FileStatus.uploading
                    ? Icon(Icons.pause, size: 20.w, color: Colors.white)
                    : Icon(Icons.play_arrow, size: 20.w, color: Colors.white),
                CircularProgressIndicator(
                  value: detail.progress.value,
                  strokeWidth: 5.w,
                  backgroundColor: Colors.black.withOpacity(0.5),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                )
              ],
            ),
          );
        case FileStatus.stopping:
          return SizedBox(
            width: 40.w,
            height: 40.w,
            child: Stack(
              alignment: Alignment.center,
              children: [
                fileIcon,
                Icon(Icons.warning_amber, size: 20.w, color: Colors.red),
              ],
            ),
          );
      }
    });
  }
}
