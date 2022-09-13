import 'package:orginone/api_resp/target_resp.dart';
import 'package:orginone/config/constant.dart';

import '../api_resp/login_resp.dart';
import '../api_resp/page_resp.dart';
import '../util/http_util.dart';

class PersonApi {
  static Future<LoginResp> login(String account, String password) async {
    String url = "${Constant.personModule}/login";
    Map<String, dynamic> data = {"account": account, "password": password};

    Map<String, dynamic> resp =
        await HttpUtil().post(url, data: data, hasToken: false);
    return LoginResp.fromMap(resp);
  }

  static Future<TargetResp> userInfo() async {
    String url = "${Constant.personModule}/query/info";

    Map<String, dynamic> resp = await HttpUtil().post(url);
    return TargetResp.fromMap(resp);
  }

  static Future<List<TargetResp>> friends(
      int limit, int offset, String filter) async {
    String url = "${Constant.personModule}/get/friends";
    Map<String, dynamic> data = {"offset": offset, "limit": limit};
    if (filter.isNotEmpty) {
      data["filter"] = filter;
    }

    Map<String, dynamic> pageResp = await HttpUtil().post(url, data: data);
    var pageData = PageResp.fromMap(pageResp);
    return pageData.result.map((item) => TargetResp.fromMap(item)).toList();
  }

  static Future<void> changeWorkspace(int targetId) async {
    Map<String, dynamic> resp = await HttpUtil().post(
        "${Constant.personModule}/change/workspace",
        data: {"id": targetId});
    return;
  }
}
