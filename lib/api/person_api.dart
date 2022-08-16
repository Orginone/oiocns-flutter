import 'package:orginone/api_resp/user_info_resp.dart';
import 'package:orginone/config/constant.dart';

import '../api_resp/login_resp.dart';
import '../model/target.dart';
import '../util/http_util.dart';

class PersonApi {
  static const loginPath = "${Constant.personModule}/login";
  static const infoPath = "${Constant.personModule}/query/info";

  static Future<LoginResp> login(String account, String password) async {
    Map<String, dynamic> resp = await HttpUtil().post(loginPath,
        data: {"account": account, "password": password}, hasToken: false);
    return LoginResp.fromMap(resp);
  }

  static Future<UserInfoResp> userInfo() async {
    Map<String, dynamic> resp = await HttpUtil().post(infoPath);
    return UserInfoResp.fromMap(resp);
  }
}
