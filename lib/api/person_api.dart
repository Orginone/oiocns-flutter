import 'package:orginone/config/constant.dart';

import '../model/login_resp.dart';
import '../model/target.dart';
import '../util/http_util.dart';

class PersonApi {
  static const loginPath = "${Constant.personModule}/login";
  static const infoPath = "${Constant.personModule}/query/info";

  static Future<LoginResp> login(String account, String password) async {
    Map<String, dynamic> resp = await HttpUtil().post(loginPath,
        data: {"account": account, "password": password}, hasToken: false);
    return LoginResp.fromJson(resp);
  }

  static Future<Target> userInfo() async {
    Map<String, dynamic> resp = await HttpUtil().post(infoPath);
    return Target.fromJson(resp);
  }
}
