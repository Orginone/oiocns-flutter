
import 'package:orginone/config/constant.dart';
import 'package:orginone/dart/base/model/page_resp.dart';
import 'package:orginone/dart/base/model/target.dart';
import 'package:orginone/util/http_util.dart';

class CohortApi {
  /// 查询加入的群组
  static Future<PageResp<Target>> cohorts(
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
    return PageResp.fromMap(pageResp, Target.fromMap);
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

  /// 群组搜索
  static Future<PageResp<Target>> search({
    required String keyword,
    required int limit,
    required int offset,
  }) async {
    String url = "${Constant.cohort}/search/cohorts";
    var data = {"filter": keyword, "limit": limit, "offset": offset};

    Map<String, dynamic> resp = await HttpUtil().post(url, data: data);
    return PageResp.fromMap(resp, Target.fromMap);
  }

  /// 创建群组
  static Future<Target> create(Map<String, dynamic> params) async {
    String url = "${Constant.cohort}/create";
    var data = {
      "code": params["code"],
      "name": params["name"],
      "teamRemark": params["remark"],
      "avatar": "123123",
    };

    Map<String, dynamic> ansMap = await HttpUtil().post(url, data: data);
    return Target.fromMap(ansMap);
  }

  /// 更新群组
  static Future<Target> update(Map<String, dynamic> params) async {
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
    Map<String, dynamic> ansMap = await HttpUtil().post(url, data: data);
    return Target.fromMap(ansMap);
  }

  /// 解散群组
  static Future<dynamic> delete(String cohortId) async {
    String url = "${Constant.cohort}/delete";
    var data = {"id": cohortId};
    return await HttpUtil().post(url, data: data);
  }

  /// 邀请好友入群
  static Future<dynamic> pull(String cohortId, List<String> targetIds) async {
    String url = "${Constant.cohort}/pull/persons";
    var data = {"id": cohortId, "targetIds": targetIds};
    return await HttpUtil().post(url, data: data);
  }
}
