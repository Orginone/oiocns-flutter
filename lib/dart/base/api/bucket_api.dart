import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:logging/logging.dart';
import 'package:orginone/config/constant.dart';
import 'package:orginone/dart/core/authority.dart';
import 'package:orginone/util/encryption_util.dart';
import 'package:orginone/util/http_util.dart';
import 'package:uuid/uuid.dart';

const String userDomain = "user";
const String allDomain = "all";

class BucketApi {
  static Logger log = Logger("BucketApi");

  static const String defaultShareDomain = userDomain;

  // 每次以 1M 的速度上传
  static int chunkSize = 1024 * 1024;

  // uuid
  static Uuid uuid = const Uuid();

  static Future<dynamic> create({
    required String prefix,
    String domain = userDomain,
  }) async {
    String url = "${Constant.bucket}/Create";
    var params = {"shareDomain": domain, "prefix": prefix};

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
    String domain = defaultShareDomain,
  }) async {
    String url = "${Constant.bucket}/Upload";

    var params = {"shareDomain": domain, "prefix": prefix};
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
    String shareDomain = defaultShareDomain,
  }) async {
    // 先读取文件大小，获取文件的长度
    var file = File(filePath);
    var length = file.lengthSync();
    var openedFile = await file.open();

    if (length < chunkSize) {
      await upload(prefix: prefix, filePath: filePath, fileName: fileName);
      if (progressCallback != null) {
        progressCallback(1.0);
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
    var totalCount = (length / chunkSize).ceil();
    var uploadId = uuid.v4();
    for (int index = 0; index < totalCount; index++) {
      Uint8List bytes = openedFile.readSync(chunkSize);

      // 组装文件
      var file = MultipartFile.fromBytes(bytes, filename: fileName);
      var chunkMetaData = {
        "UploadId": uploadId,
        "FileName": fileName,
        "Index": index,
        "TotalCount": totalCount,
        "FileSize": length
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

      if (progressCallback != null) {
        progressCallback((index + 1) / totalCount);
      }
    }
  }

  static Future<File> getCachedFile({
    required String path,
    String domain = defaultShareDomain,
  }) async {
    path = EncryptionUtil.encodeURLString(path);
    String params = "shareDomain=$domain&prefix=$path&preview=False";
    String url = "${Constant.bucket}/Download?$params";

    Map<String, String> headers = {
      "Authorization": getAccessToken,
    };
    return await DefaultCacheManager().getSingleFile(url, headers: headers);
  }
}
