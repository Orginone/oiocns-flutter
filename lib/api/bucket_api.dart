import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:orginone/util/hive_util.dart';

import '../config/constant.dart';
import '../util/http_util.dart';

class BucketApi {
  static String shareDomain = "user";

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

  static Future<File> getCachedFile(String prefix, String fileName) async {
    String params = "shareDomain=$shareDomain&prefix=$prefix&preview=$fileName";
    String url = "${Constant.bucket}/Download?$params";

    Map<String, String> headers = {
      "Authorization": HiveUtil().accessToken,
    };
    return await DefaultCacheManager().getSingleFile(url, headers: headers);
  }
}
