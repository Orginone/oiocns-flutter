import 'package:flutter/material.dart';
import 'package:orginone/dart/core/thing/file_info.dart';
import 'package:orginone/images.dart';

class FileImageWidget extends StatelessWidget {
  final double size;
  final ISysFileInfo file;

  const FileImageWidget({Key? key, this.size = 44.0, required this.file})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String img = Images.otherIcon;
    String ext = file.metadata!.name!.split('.').last.toLowerCase();
    if (ext == 'jpg' || ext == 'jpeg' || ext == 'png' || ext == 'webp') {
      return Image.network(
        file.shareInfo().shareLink!,
        width: size,
        height: size,
      );
    } else {
      switch (ext) {
        case "xlsx":
        case "xls":
        case "excel":
          img = Images.excelIcon;
          break;
        case "pdf":
          img = Images.pdfIcon;
          break;
        case "ppt":
          img = Images.pptIcon;
          break;
        case "docx":
        case "doc":
          img = Images.wordIcon;
          break;
        default:
          img = Images.otherIcon;
          break;
      }
    }

    return Image.asset(
      img,
      width: size,
      height: size,
    );
  }
}
