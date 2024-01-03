import 'dart:convert';
import 'dart:math';

import 'package:archive/archive.dart';

class EncryptionUtil {
  static String prefix = "^!:";
  static String chars = 'ABCDEFGHJKMNPQRSTWXYZabcdefhijkmnprstwxyz2345678';
  static Random random = Random();

  /// 解压缩
  static String inflate(String target) {
    if (target.startsWith(prefix)) {
      try {
        // 转换目标
        String targetPart = target.substring(8, target.length - 5);
        String converted = targetPart.replaceAll("*", "=");
        // base64 解码
        List<int> convertedBytes = const Base64Decoder().convert(converted);
        // 解压缩并返回
        String ans =
            utf8.decode(const ZLibDecoder().decodeBytes(convertedBytes));
        return Uri.decodeComponent(ans);
      } catch (error) {
        return target;
      }
    }
    return target;
  }

  /// 压缩
  static String deflate(String target) {
    // uri 编码， - _ . ! ~ * ' ( ) 等字符用转义字符
    target = Uri.encodeComponent(target);
    // 压缩
    List<int> deflatedBytes = const ZLibEncoder().encode(utf8.encode(target));
    // 转成 base64
    String convertedStr = const Base64Encoder().convert(deflatedBytes);
    // 解析返回
    return "$prefix${randomStr(5)}${convertedStr.replaceAll("=", "*")}${randomStr(5)}";
  }

  static String randomStr(int len) {
    len = len < 1 ? 32 : len;
    var maxPos = chars.length;
    var str = '';
    for (var i = 0, j = len; i < j; ++i) {
      str += chars[random.nextInt(maxPos)];
    }
    return str;
  }

  static String encodeURLString(String target){
    target = Uri.encodeFull(target);
    return const Base64Encoder().convert(utf8.encode(target));
  }

  static String decodeURLString(String target){
    target = utf8.decode(const Base64Decoder().convert(target));
    return Uri.decodeFull(target);
  }
}
