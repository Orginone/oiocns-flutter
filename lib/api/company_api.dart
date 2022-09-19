import '../api_resp/page_resp.dart';
import '../api_resp/target_resp.dart';
import 'constant.dart';
import '../util/http_util.dart';

class CompanyApi {
  static Future<List<dynamic>> getJoinedCompanys(int offset, int limit) async {
    String url = "${Constant.company}/get/joined/companys";
    Map<String, dynamic> data = {"offset": offset, "limit": limit};
    Map<String, dynamic> resp = await HttpUtil().post(url, data: data);

    PageResp pageResp = PageResp.fromMap(resp);
    return pageResp.result;
  }

  static Future<TargetResp> queryInfo() async {
    String url = "${Constant.company}/query/info";
    Map<String, dynamic> resp = await HttpUtil().post(url);

    TargetResp targetResp = TargetResp.fromMap(resp);
    return targetResp;
  }

  static Future<List<TargetResp>> groups(
      int limit, int offset, String filter) async {
    String url = "${Constant.company}/get/groups";
    Map<String, dynamic> data = {"offset": offset, "limit": limit};
    if (filter.isNotEmpty) {
      data["filter"] = filter;
    }

    Map<String, dynamic> pageResp = await HttpUtil().post(url, data: data);
    var pageData = PageResp.fromMap(pageResp);
    return pageData.result.map((item) => TargetResp.fromMap(item)).toList();
  }
}
