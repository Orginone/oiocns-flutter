import 'package:orginone/api/constant.dart';

import '../util/http_util.dart';

class CollectionApi {
  static String insertPrefix = "${Constant.collection}/insert/";
  static String updatePrefix = "${Constant.collection}/update/";
  static String removePrefix = "${Constant.collection}/remove/";
  static String aggregatePrefix = "${Constant.collection}/aggregate/";

  static Future<dynamic> insert(
      String collName, dynamic data, String domain) async {
    String url = "$insertPrefix$collName";
    Map<String, dynamic> params = {"shareDomain": domain};
    return await HttpUtil().post(url, data: data, queryParameters: params);
  }

  static Future<dynamic> update(
      String collName, dynamic update, String domain) async {
    String url = "$updatePrefix$collName";
    Map<String, dynamic> params = {"shareDomain": domain};
    return await HttpUtil().post(url, data: update, queryParameters: params);
  }

  static Future<dynamic> remove(
      String collName, dynamic match, String domain) async {
    String url = "$removePrefix$collName";
    Map<String, dynamic> params = {"shareDomain": domain};
    return await HttpUtil().post(url, data: match, queryParameters: params);
  }

  static Future<dynamic> aggregate(
      String collName, dynamic options, String domain) async {
    String url = "$aggregatePrefix$collName";
    Map<String, dynamic> params = {"shareDomain": domain};
    return await HttpUtil().post(url, data: options, queryParameters: params);
  }
}
