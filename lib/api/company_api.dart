import '../api_resp/page_resp.dart';
import '../api_resp/target_resp.dart';
import '../config/constant.dart';
import '../util/http_util.dart';

class CompanyApi {
  static Future<List<dynamic>> getJoinedCompanys(int offset, int limit) async {
    String url = "${Constant.companyModule}/get/joined/companys";
    Map<String, dynamic> data = {"offset": offset, "limit": limit};
    Map<String, dynamic> resp = await HttpUtil().post(url, data: data);

    PageResp pageResp = PageResp.fromMap(resp);
    return pageResp.result;
  }

  static Future<TargetResp> queryInfo() async {
    String url = "${Constant.companyModule}/query/info";
    Map<String, dynamic> resp = await HttpUtil().post(url);

    TargetResp targetResp = TargetResp.fromMap(resp);
    return targetResp;
  }
}
