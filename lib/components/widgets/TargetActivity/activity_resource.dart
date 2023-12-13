import 'package:flutter/widgets.dart';
import 'package:orginone/common/values/images.dart';
import 'package:orginone/components/widgets/image_widget.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/work/rules/lib/tools.dart';

class ActivityResourceWidget {
  List<FileItemShare> fileList;
  double maxWidth;
  int columns;

  ActivityResourceWidget(this.fileList, this.maxWidth, {this.columns = 3});

  List<Widget> build(Object context) {
    return fileList.map((item) => renderResource(item)!).toList() ?? [];
  }

  double computedSize() {
    if (fileList.length >= columns) {
      return maxWidth / columns - 8;
    } else if (fileList.length > 1) {
      return maxWidth / fileList.length - 8;
    }
    return maxWidth - 8;
  }

  Widget? renderResource(FileItemShare item) {
    if (item.contentType!.startsWith('image')) {
      return ImageWidget(shareOpenLink(item.shareLink), size: computedSize());
    } else if (item.contentType!.startsWith('video')) {
      return ImageWidget(
          item.poster != null && item.poster!.isNotEmpty
              ? shareOpenLink(item.poster)
              : item.thumbnailUint8List,
          size: computedSize());
    } else if (item.contentType!.contains('pdf') ||
        item.contentType!.startsWith('text')) {
      return getThumbnail(shareOpenLink(item.shareLink));
    }
    return null;
  }

  Widget getThumbnail(String path) {
    String img = AssetsImages.otherIcon;
    String ext =
        path.substring(path.lastIndexOf('.'), path.length).toLowerCase() ?? "";
    if (ext == '.jpg' || ext == '.jpeg' || ext == '.png' || ext == '.webp') {
      img = path;
    } else {
      switch (ext) {
        case ".xlsx":
        case ".xls":
        case ".excel":
          img = AssetsImages.excelIcon;
          break;
        case ".pdf":
          img = AssetsImages.pdfIcon;
          break;
        case ".ppt":
          img = AssetsImages.pptIcon;
          break;
        case ".docx":
        case ".doc":
          img = AssetsImages.wordIcon;
          break;
        default:
          img = AssetsImages.otherIcon;
          break;
      }
    }
    return ImageWidget(img);
  }

  // GridView.extent(
  //       maxCrossAxisExtent: maxWidth,
  //       padding: const EdgeInsets.all(4),
  //       mainAxisSpacing: 4,
  //       crossAxisSpacing: 4,
  //       children:
  //     )
}
