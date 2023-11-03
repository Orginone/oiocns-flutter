/*
 * @Descripttion: 
 * @version: 
 * @Author: congsir
 * @Date: 2022-11-26 15:59:35
 * @LastEditors: Please set LastEditors
 * @LastEditTime: 2022-12-08 20:40:18
 */
import 'package:encrypt/encrypt.dart';
import 'package:orginone/common/index.dart';

/// 加密类
class EncryptUtil {
  static final EncryptUtil _instance = EncryptUtil._internal();
  factory EncryptUtil() => _instance;
  EncryptUtil._internal() {
    encrypter = Encrypter(AES(
      key,
      mode: AESMode.ecb,
      // padding: 'PKCS7',
    ));
  }

  final key = Key.fromUtf8(Constants.aesKey);
  // final iv = IV.fromUtf8(Constants.aesIV);
  final iv = IV.fromLength(16);
  late Encrypter encrypter;

  /// aes加密
  String aesEncode(String content) {
    final encrypted = encrypter.encrypt(content, iv: iv);
    return encrypted.base64;
  }
}
