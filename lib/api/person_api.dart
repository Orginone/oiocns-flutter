import 'package:orginone/api_resp/target_resp.dart';
import 'package:orginone/config/constant.dart';

import '../api_resp/login_resp.dart';
import '../api_resp/page_resp.dart';
import '../util/http_util.dart';

class PersonApi {
  static Future<Map<String, dynamic>> regist(dynamic postData) async {
    String url = "${Constant.person}/register";
    Map<String, dynamic> resp = await HttpUtil().post(url, data: postData);
    return resp;
  }

  static Future<LoginResp> login(String account, String password) async {
    String url = "${Constant.person}/login";
    Map<String, dynamic> data = {"account": account, "password": password};

    Map<String, dynamic> resp =
        await HttpUtil().post(url, data: data, hasToken: false);
    return LoginResp.fromMap(resp);
  }

  static Future<Map<String, dynamic>> logout(dynamic postData) async {
    String url = "${Constant.person}/logout";
    Map<String, dynamic> resp = await HttpUtil().post(url, data: postData);
    return resp;
  }

  static Future<Map<String, dynamic>> resetPwd(dynamic postData) async {
    String url = "${Constant.person}/reset/pwd";
    Map<String, dynamic> resp = await HttpUtil().post(url, data: postData);
    return resp;
  }

  static Future<TargetResp> userInfo() async {
    String url = "${Constant.person}/query/info";

    Map<String, dynamic> resp = await HttpUtil().post(url);
    return TargetResp.fromMap(resp);
  }

  //更新用户信息
  static Future<String> updateUser(dynamic postData) async {
    await HttpUtil().post("${Constant.person}/update", data: postData);
    return '修改成功';
  }

  static Future<List<TargetResp>> friends(
      int limit, int offset, String filter) async {
    String url = "${Constant.person}/get/friends";
    Map<String, dynamic> data = {"offset": offset, "limit": limit};
    if (filter.isNotEmpty) {
      data["filter"] = filter;
    }

    Map<String, dynamic> pageResp = await HttpUtil().post(url, data: data);
    var pageData = PageResp.fromMap(pageResp);
    return pageData.result.map((item) => TargetResp.fromMap(item)).toList();
  }

  static Future<LoginResp> changeWorkspace(String targetId) async {
    String url = "${Constant.person}/change/workspace";
    Map<String, dynamic> res =
        await HttpUtil().post(url, data: {"id": targetId});
    return LoginResp.fromMap(res);
  }

  //获取人员详情（目前用搜索接口替代）
  static Future<TargetResp> getPersonDetail(String personPhone) async {
    Map<String, dynamic> resp =
        await HttpUtil().post("${Constant.person}/search/persons", data: {
      "filter": personPhone,
      "limit": 20,
      "offset": 0,
    });

    return TargetResp.fromMap(resp["result"][0]);
  }

  //好友验证
  static Future<String> addPerson(String personId) async {
    await HttpUtil()
        .post("${Constant.person}/apply/join", data: {"id": personId});
    return '发起申请';
  }
}
