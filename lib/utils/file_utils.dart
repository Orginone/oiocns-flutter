import 'dart:typed_data';

import 'package:photo_manager/photo_manager.dart';

class FileUtils {
  static bool isAssetsImg(String imageName) {
    return imageName.startsWith("assets");
  }

  static bool isNotAssetsImg(String imageName) {
    return !isAssetsImg(imageName);
  }

  static bool isBase64Image(String imageName) {
    return imageName.contains('base64');
  }

  static bool isNetworkImg(String imageName) {
    return imageName.startsWith("http://") || imageName.startsWith("https://");
  }

  static bool isAssetsSvg(String imageName) {
    return imageName.endsWith("svg");
  }

  static bool isNotNetworkImg(String imageName) {
    return !isNetworkImg(imageName);
  }

  static Future<Uint8List?> thumbData(AssetEntity asset) {
    double ratio = 1;
    if (asset.width > 2160) {
      ratio = 2160 / asset.width;
    }
    return asset.thumbnailDataWithSize(
        ThumbnailSize(int.parse((asset.width * ratio).toStringAsFixed(0)),
            int.parse((asset.height * ratio).toStringAsFixed(0))),
        quality: 80);
    // return asset.originBytes;
  }

  static bool isPdf(String extension) => extension.contains("pdf");

  static bool isVideo(String extension) =>
      extension.contains("avi") ||
      extension.contains("wmv") ||
      extension.contains("mpg") ||
      extension.contains("mov") ||
      extension.contains("fly") ||
      extension.contains("mp4");

  static bool isImage(String extension) =>
      extension.contains("png") ||
      extension.contains("jpg") ||
      extension.contains("jpeg") ||
      extension.contains("jfif") ||
      extension.contains("webp");

  static bool isWord(String extension) =>
      extension.contains("docx") ||
      extension.contains("doc") ||
      extension.contains("xlsx") ||
      extension.contains("xls") ||
      extension.contains("pptx") ||
      extension.contains("txt");
  static bool isMarkDown(String extension) => extension.contains("md");
}
