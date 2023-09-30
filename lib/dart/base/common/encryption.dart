import 'package:encrypt/encrypt.dart';

String encrypt(String secret, String word) {
  final key = Key.fromUtf8(secret);
  final iv = IV.fromLength(16);
  final encrypter = Encrypter(AES(key, mode: AESMode.ecb));
  final encrypted = encrypter.encrypt(word, iv: iv);
  return encrypted.base64;
}

String decrypt(String password, String word) {
  final key = Key.fromUtf8(password);
  final iv = IV.fromLength(16);
  final encrypter = Encrypter(AES(key, mode: AESMode.ecb));
  final decrypted = encrypter.decrypt64(word, iv: iv);
  return decrypted;
}
