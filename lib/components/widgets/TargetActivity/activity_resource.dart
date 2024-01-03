import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:orginone/common/values/images.dart';
import 'package:orginone/components/widgets/image_widget.dart';
import 'package:orginone/components/widgets/photo_widget.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/work/rules/lib/tools.dart';

class ActivityResourceWidget extends StatelessWidget {
  List<FileItemShare> fileList;
  double maxWidth;
  int columns;

  ActivityResourceWidget(this.fileList, this.maxWidth,
      {super.key, this.columns = 3}) {
    columns = min(3, fileList.length);
  }

  @override
  Widget build(BuildContext context) {
    int i = 0;
    List<Widget> widgetList = [];
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: columns,
      padding: const EdgeInsets.all(4),
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      childAspectRatio: 1,
      children: fileList
              .map((item) => Container(
                  child: renderResource(context, item, widgetList, i++)!))
              .toList() ??
          [],
    );
  }

  double computedSize() {
    if (fileList.length >= columns) {
      return maxWidth / columns - 8;
    } else if (fileList.length > 1) {
      return maxWidth / fileList.length - 8;
    }
    return maxWidth - 8;
  }

  Widget? renderResource(BuildContext context, FileItemShare item,
      List<Widget> widgetList, int index) {
    if (item.contentType?.startsWith('image') ?? false) {
      // 获取屏幕高度
      final height = MediaQuery.of(context).size.height;
      String link = shareOpenLink(item.shareLink);
      widgetList.add(PhotoWidget(
        imageProvider: CachedNetworkImageProvider(link),
      ));
      return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              DialogRoute(
                context: context,
                builder: (BuildContext context) {
                  return CarouselSlider(
                      options: CarouselOptions(
                        height: height,
                        initialPage: index,
                        viewportFraction: 1,
                      ),
                      items: widgetList);
                },
              ),
            );
          },
          child: ImageWidget(
            link,
          ));
    } else if (item.contentType?.startsWith('video') ?? false) {
      return ImageWidget(
          item.poster != null && item.poster!.isNotEmpty
              ? shareOpenLink(item.poster)
              : item.thumbnailUint8List,
          size: computedSize());
    } else if ((item.contentType?.contains('pdf') ?? false) ||
        (item.contentType?.startsWith('text') ?? false)) {
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
