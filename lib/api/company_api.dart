import '../api_resp/page_resp.dart';
import '../config/constant.dart';
import '../util/http_util.dart';

class CompanyApi {
  static Future<List<dynamic>> getJoinedCompanys(int offset, int limit) async {
    Map<String, dynamic> resp = await HttpUtil().post(
        "${Constant.companyModule}/get/joined/companys",
        data: {"offset": offset, "limit": limit});

    PageResp pageResp = PageResp.fromMap(resp);
    return pageResp.result;
  }
}
