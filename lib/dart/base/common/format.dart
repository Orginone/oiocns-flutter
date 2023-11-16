import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:get/get.dart';

const sizeUnits = ['', 'KB', 'MB', 'GB', 'TB', 'PB'];

/// 格式化大小
String formatSize(int size, [String unit = '']) {
  if (size > 1024) {
    final index = sizeUnits.indexOf(unit);
    if (index + 2 < sizeUnits.length) {
      return formatSize((size / 1024.0).round(), sizeUnits[index + 1]);
    }
  }
  return '$size$unit';
}

/// 编码路径
String encodeKey(String key) {
  return base64.encode(utf8.encode(key));
}

/// 将文件切片
List<Uint8List> sliceFile(Uint8List file, int chunkSize) {
  final slices = <Uint8List>[];
  var index = 0;
  while (index * chunkSize < file.length) {
    var start = index * chunkSize;
    var end = start + chunkSize;
    if (end > file.length) {
      end = file.length;
    }
    slices.add(file.sublist(start, end));
    index++;
  }
  return slices;
}

/// 将文件读成 Data URL
Future<String> blobToDataUrl(Uint8List file) async {
  final base64Data = base64.encode(file);
  return base64Data;
}

/// 将文件读成字节数组
Future<List<int>> blobToNumberArray(Uint8List file) async {
  return file.toList();
}

/// 字符串压缩解压缩
class StringGzip {
  /// 解压缩
  static String inflate(String input) {
    if (input.startsWith('^!:')) {
      try {
        List<int> convertedBytes = base64
            .decode(input.substring(8, input.length - 5).replaceAll('*', '='));
        final output = utf8.decode(gzip.decode(convertedBytes));
        return Uri.decodeComponent(output);
      } catch (err) {
        err.printError();
        return input;
      }
    }
    return input;
  }

  /// 压缩
  static String deflate(String input) {
    input = Uri.encodeComponent(input);
    final output =
        base64.encode(gzip.encode(utf8.encode(input))).replaceAll('=', '*');
    var endStr = randomStr(5);
    String str = '^!:${randomStr(5)}$output${randomStr(5)}';
    print(str);
    return str;
  }

  /// 生成随机字符串
  static String randomStr(int len) {
    len = len ?? 32;
    const chars = 'ABCDEFGHJKMNPQRSTWXYZabcdefhijkmnprstwxyz2345678';
    const maxPos = chars.length;
    var str = '';
    for (var i = 0; i < len; ++i) {
      str += chars[(Random().nextDouble() * maxPos).floor()];
    }
    return str;
  }
}
