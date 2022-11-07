import '../api_resp/page_resp.dart';
import '../api_resp/target_resp.dart';
import '../config/constant.dart';
import '../util/http_util.dart';

class CohortApi {
  /// 查询加入的群组
  static Future<PageResp<TargetResp>> cohorts(
    int limit,
    int offset,
    String filter,
  ) async {
    String url = "${Constant.cohort}/get/joined/cohorts";
    Map<String, dynamic> data = {"offset": offset, "limit": limit};
    if (filter.isNotEmpty) {
      data["filter"] = filter;
    }

    Map<String, dynamic> pageResp = await HttpUtil().post(url, data: data);
    return PageResp.fromMap(pageResp, TargetResp.fromMap);
  }

  /// 退出群组
  static Future<dynamic> exit(String cohortId) async {
    String url = "${Constant.cohort}/exit";
    Map<String, dynamic> data = {"id": cohortId};

    return await HttpUtil().post(url, data: data);
  }

  /// 加入群组
  static Future<dynamic> join(String cohortId) async {
    String url = "${Constant.cohort}/apply/join";
    Map<String, dynamic> data = {"id": cohortId};

    return await HttpUtil().post(url, data: data);
  }

  /// 人员搜索
  static Future<PageResp<TargetResp>> search({
    required String keyword,
    required int limit,
    required int offset,
  }) async {
    String url = "${Constant.cohort}/search/cohorts";
    var data = {"filter": keyword, "limit": limit, "offset": offset};

    Map<String, dynamic> resp = await HttpUtil().post(url, data: data);
    return PageResp.fromMap(resp, TargetResp.fromMap);
  }

  /// 创建群组
  static Future<dynamic> create(Map<String, dynamic> params) async {
    String url = "${Constant.cohort}/create";
    var data = {
      "code": params["code"],
      "name": params["name"],
      "teamRemark": params["remark"],
    };

    return await HttpUtil().post(url, data: data);
  }

  /// 创建群组
  static Future<dynamic> update(Map<String, dynamic> params) async {
    String url = "${Constant.cohort}/update";
    var data = {
      "id": params["id"],
      "code": params["code"],
      "name": params["name"],
      "teamCode": params["code"],
      "teamName": params["name"],
      "teamRemark": params["remark"],
      "thingId": params["thingId"],
      "belongId": params["belongId"],
    };
    return await HttpUtil().post(url, data: data);
  }

  /// 解散群组
  static Future<dynamic> delete(String cohortId) async {
    String url = "${Constant.cohort}/delete";
    var data = {"id": cohortId};
    return await HttpUtil().post(url, data: data);
  }
}
