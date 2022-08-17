import 'package:orginone/api_resp/target_resp.dart';
import 'package:orginone/config/constant.dart';

import '../api_resp/login_resp.dart';
import '../util/http_util.dart';

class PersonApi {
  static Future<LoginResp> login(String account, String password) async {
    Map<String, dynamic> resp = await HttpUtil().post(
        "${Constant.personModule}/login",
        data: {"account": account, "password": password},
        hasToken: false);
    return LoginResp.fromMap(resp);
  }

  static Future<TargetResp> userInfo() async {
    Map<String, dynamic> resp =
        await HttpUtil().post("${Constant.personModule}/query/info");
    return TargetResp.fromMap(resp);
  }
}
