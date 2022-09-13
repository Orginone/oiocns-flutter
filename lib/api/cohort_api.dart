import '../api_resp/page_resp.dart';
import '../api_resp/target_resp.dart';
import '../config/constant.dart';
import '../util/http_util.dart';

class CohortApi {
  static Future<List<TargetResp>> cohorts(
      int limit, int offset, String filter) async {
    String url = "${Constant.cohortModule}/get/joined/cohorts";
    Map<String, dynamic> data = {"offset": offset, "limit": limit};
    if (filter.isNotEmpty) {
      data["filter"] = filter;
    }

    Map<String, dynamic> pageResp = await HttpUtil().post(url, data: data);
    var pageData = PageResp.fromMap(pageResp);
    return pageData.result.map((item) => TargetResp.fromMap(item)).toList();
  }
}
