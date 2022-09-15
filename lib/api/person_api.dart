import 'package:orginone/api_resp/person_detail_resp.dart';
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

  static Future<LoginResp> changeWorkspace(int targetId) async {
    String url = "${Constant.personModule}/change/workspace";
    Map<String, dynamic> res = await HttpUtil().post(url, data: {"id": targetId});
    return LoginResp.fromMap(res);
  }

  //获取人员详情（目前用搜索接口替代）
  static Future<PersonDetailResp> getPersonDetail(String personName) async {
    Map<String, dynamic> resp = await HttpUtil().post("${Constant.personModule}/search/persons",
        data: {
          "filter": personName,
          "limit": 20,
          "offset": 0,
        });
    return PersonDetailResp.fromMap(resp["result"][0]);
  }

  //好友验证
  static Future<String> addPerson(String personId) async {
    Map<String, dynamic> resp = await HttpUtil().post("${Constant.personModule}/apply/join",
        data: {
          "id": personId
        });
    return resp['msg'];
  }
}
