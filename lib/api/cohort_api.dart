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
  static Future<dynamic> exit(String id) async {
    String url = "${Constant.cohort}/exit";
    Map<String, dynamic> data = {"id": id};

    return await HttpUtil().post(url, data: data);
  }

  /// 加入群组
  static Future<dynamic> join(String id) async {
    String url = "${Constant.cohort}/apply/join";
    Map<String, dynamic> data = {"id": id};

    return await HttpUtil().post(url, data: data);
  }

  /// 人员搜索
  static Future<PageResp<TargetResp>> searchCohorts({
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
  static Future<dynamic> createCohort({
    required String code,
    required String name,
    required String teamRemark,
  }) async {
    String url = "${Constant.cohort}/create";
    var data = {"code": code, "name": name, "teamRemark": teamRemark};

    return await HttpUtil().post(url, data: data);
  }
}
