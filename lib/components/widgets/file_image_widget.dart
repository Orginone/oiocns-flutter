import 'package:flutter/material.dart';
import 'package:orginone/common/values/index.dart';
import 'package:orginone/dart/core/thing/systemfile.dart';

class FileImageWidget extends StatelessWidget {
  final double size;
  final ISysFileInfo file;

  const FileImageWidget({Key? key, this.size = 44.0, required this.file})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String img = AssetsImages.otherIcon;
    String ext = file.metadata.name!.split('.').last.toLowerCase();
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
          img = AssetsImages.excelIcon;
          break;
        case "pdf":
          img = AssetsImages.pdfIcon;
          break;
        case "ppt":
          img = AssetsImages.pptIcon;
          break;
        case "docx":
        case "doc":
          img = AssetsImages.wordIcon;
          break;
        default:
          img = AssetsImages.otherIcon;
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
