import 'package:dio/dio.dart';

import '../config/constant.dart';
import '../util/http_util.dart';

class BucketApi {
  static Future<void> upload({
    required String prefix,
    required String filePath,
    required String fileName,
  }) async {
    String url = "${Constant.bucket}/Upload";

    var params = {"shareDomain": "user", "prefix": prefix};
    var formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(filePath, filename: fileName),
    });
    await HttpUtil().post(
      url,
      queryParameters: params,
      data: formData,
      options: Options(contentType: "multipart/form-data"),
    );
  }
}
