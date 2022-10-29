import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:logging/logging.dart';
import 'package:orginone/util/encryption_util.dart';
import 'package:orginone/util/hive_util.dart';
import 'package:uuid/uuid.dart';

import '../config/constant.dart';
import '../util/http_util.dart';

class BucketApi {
  static Logger log = Logger("BucketApi");

  static String shareDomain = "user";

  // 每次以 1M 的速度上传
  static int chunkSize = 1024 * 1024;

  // uuid
  static Uuid uuid = const Uuid();

  static Future<dynamic> create({required String prefix}) async {
    String url = "${Constant.bucket}/Create";
    var params = {"shareDomain": shareDomain, "prefix": prefix};

    return await HttpUtil().post(
      url,
      queryParameters: params,
      showError: false,
    );
  }

  static Future<void> upload({
    required String prefix,
    required String filePath,
    required String fileName,
  }) async {
    String url = "${Constant.bucket}/Upload";

    var params = {"shareDomain": shareDomain, "prefix": prefix};
    var file = await MultipartFile.fromFile(filePath, filename: fileName);
    var formData = FormData.fromMap({"file": file});

    await HttpUtil().post(
      url,
      queryParameters: params,
      data: formData,
      options: Options(contentType: "multipart/form-data"),
    );
  }

  static Future<void> uploadChunk({
    required String prefix,
    required String filePath,
    required String fileName,
    Function? progressCallback,
  }) async {
    // 先读取文件大小，获取文件的长度
    var file = File(filePath);
    var length = file.lengthSync();
    var openedFile = await file.open();

    if (length < chunkSize){
      await upload(prefix: prefix, filePath: filePath, fileName: fileName);
      if (progressCallback != null){
        progressCallback(100);
      }
      return;
    }

    // 上传地址
    String url = "${Constant.bucket}/UploadChunk";
    var params = {
      "shareDomain": shareDomain,
      "prefix": prefix,
    };

    // 当前进度
    var current = 0;
    var index = 0;
    var totalCount = (length / chunkSize).ceil();
    var uploadId = uuid.v4();
    while (current < length) {
      // 获取字节流
      var remainder = length - current;
      int readSize = remainder < chunkSize ? remainder : chunkSize;
      Uint8List bytes = openedFile.readSync(readSize);

      // 组装文件
      var file = MultipartFile.fromBytes(bytes, filename: fileName);
      var chunkMetaData = {
        "uploadId": uploadId,
        "fileName": fileName,
        "Index": index++,
        "TotalCount": totalCount,
        "FileSize": readSize
      };
      var formData = FormData.fromMap({
        "file": file,
        "chunkMetadata": jsonEncode(chunkMetaData),
      });

      // 包装上传
      await HttpUtil().post(
        url,
        queryParameters: params,
        data: formData,
        options: Options(contentType: "multipart/form-data"),
      );

      current += readSize;
      if (progressCallback != null) {
        progressCallback(current / length);
      }
    }
  }

  static Future<File> getCachedFile(String path) async {
    path = EncryptionUtil.encodeURLString(path);
    String params = "shareDomain=$shareDomain&prefix=$path&preview=False";
    String url = "${Constant.bucket}/Download?$params";

    Map<String, String> headers = {
      "Authorization": HiveUtil().accessToken,
    };
    return await DefaultCacheManager().getSingleFile(url, headers: headers);
  }
}
