import 'package:flutter/material.dart';
import 'package:orginone/dart/core/thing/filesys/filesystem.dart';
import 'package:orginone/images.dart';

class FileImageWidget extends StatelessWidget {
  final double size;
  final IFileSystemItem file;

  const FileImageWidget({Key? key, this.size = 44.0, required this.file})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String img = Images.otherIcon;
    String ext = file.metadata!.name!.split('.').last;
    if (ext == 'jpg' || ext == 'jpeg' || ext == 'png' || ext == 'webp') {
      return Image.network(
        file.metadata?.shareInfo()['shareLink'],
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
          if(file.metadata.isDirectory??false){
            img = Images.dirIcon;
          }else{
            img = Images.otherIcon;
          }
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
