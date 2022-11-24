import 'package:orginone/api_resp/target_resp.dart';
import 'package:orginone/config/constant.dart';

import '../api_resp/friends_entity.dart';
import '../api_resp/login_resp.dart';
import '../api_resp/page_resp.dart';
import '../api_resp/token_authority_resp.dart';
import '../util/http_util.dart';

class PersonApi {
  static Future<Map<String, dynamic>> register(dynamic postData) async {
    String url = "${Constant.person}/register";
    return await HttpUtil().post(url, data: postData);
  }

  static Future<Map<String, dynamic>> logout(dynamic postData) async {
    String url = "${Constant.person}/logout";
    return await HttpUtil().post(url, data: postData);
  }

  static Future<Map<String, dynamic>> resetPwd(dynamic postData) async {
    String url = "${Constant.person}/reset/pwd";
    return await HttpUtil().post(url, data: postData);
  }

  static Future<Target> userInfo() async {
    String url = "${Constant.person}/query/info";

    Map<String, dynamic> resp = await HttpUtil().post(url);
    return Target.fromMap(resp);
  }

  static Future<LoginResp> login(String account, String password) async {
    String url = "${Constant.person}/login";
    Map<String, dynamic> data = {"account": account, "password": password};

    Map<String, dynamic> resp =
    await HttpUtil().post(url, data: data, hasToken: false);
    return LoginResp.fromMap(resp);
  }

  static Future<TokenAuthorityResp> tokenInfo() async {
    String url = "${Constant.person}/token/info";

    Map<String, dynamic> resp = await HttpUtil().post(url);
    return TokenAuthorityResp.fromMap(resp);
  }

  /// 更新用户信息
  static Future<String> updateUser(dynamic postData) async {
    await HttpUtil().post("${Constant.person}/update", data: postData);
    return '修改成功';
  }

  /// 好友
  static Future<PageResp<Target>> friends(
    int limit,
    int offset,
    String filter,
  ) async {
    String url = "${Constant.person}/get/friends";
    Map<String, dynamic> data = {"offset": offset, "limit": limit};
    if (filter.isNotEmpty) {
      data["filter"] = filter;
    }

    Map<String, dynamic> pageResp = await HttpUtil().post(url, data: data);
    return PageResp.fromMap(pageResp, Target.fromMap);
  }

  /// 获取所有好友
  static Future<List<Target>> friendsAll(String filter) async {
    List<Target> allFriends = [];
    while (true) {
      PageResp<Target> tempPage = await friends(50, 0, filter);
      allFriends.addAll(tempPage.result);
      if (tempPage.result.length == allFriends.length) {
        break;
      }
    }
    return allFriends;
  }

  /// 改变工作空间
  static Future<LoginResp> changeWorkspace(String targetId) async {
    String url = "${Constant.person}/change/workspace";
    var data = {"id": targetId};
    Map<String, dynamic> res = await HttpUtil().post(url, data: data);
    return LoginResp.fromMap(res);
  }

  /// 人员搜索
  static Future<PageResp<Target>> searchPersons({
    required String keyword,
    required int limit,
    required int offset,
  }) async {
    String url = "${Constant.person}/search/persons";
    var data = {"filter": keyword, "limit": limit, "offset": offset};
    Map<String, dynamic> resp = await HttpUtil().post(url, data: data);
    return PageResp.fromMap(resp, Target.fromMap);
  }

  /// 好友验证
  static Future<dynamic> join(String targetId) async {
    String url = "${Constant.person}/apply/join";
    return await HttpUtil().post(url, data: {"id": targetId});
  }

  /// 人员搜索
  static Future<int> approval() async {
    String url = "${Constant.person}/get/all/approval";
    var data = {"id": 0, "limit": 0, "offset": 0};
    Map<String, dynamic> resp = await HttpUtil().post(url, data: data);
    return resp["total"] ?? 0;
  }

  /// 查询好友申请
  static Future<PageResp<FriendsEntity>> approvalAll(
      String id, int limit, int offset) async {
    String url = "${Constant.person}/get/all/approval";
    var data = {"id": id, "limit": limit, "offset": offset};
    Map<String, dynamic> pageResp = await HttpUtil().post(url, data: data);
    return PageResp.fromMap(pageResp, FriendsEntity.fromJson);
  }

  /// 加好友通过
  static Future<bool> joinSuccess(String id) async {
    String url = "${Constant.person}/join/success";
    var data = {"id": id};
    Map<String, dynamic> resp =
        await HttpUtil().post(url, data: data, showError: true);
    return resp != null;
  }

  /// 加好友拒绝
  static Future<bool> joinRefuse(String id) async {
    String url = "${Constant.person}/join/refuse";
    var data = {"id": id};
    Map<String, dynamic> resp =
        await HttpUtil().post(url, data: data, showError: true);
    return resp != null;
  }

  /// 人员搜索
  static Future<int> apply() async {
    String url = "${Constant.person}/get/all/apply";
    var data = {"limit": 0, "offset": 0};
    Map<String, dynamic> resp = await HttpUtil().post(url, data: data);
    return resp["total"] ?? 0;
  }

  /// 好友删除
  static Future<dynamic> remove(String id) async {
    String url = "${Constant.person}/remove";
    var data = {
      "id": id,
      "targetIds": [id]
    };
    return await HttpUtil().post(url, data: data);
  }
}
