import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:orginone/api/person_api.dart';
import 'package:orginone/api_resp/target_resp.dart';

import '../../api_resp/login_resp.dart';
import '../../model/db_model.dart';
import '../../util/hive_util.dart';

class LoginController extends GetxController {
  var account = TextEditingController(text: "15168347908");
  var password = TextEditingController(text: "38179960Jzy~");

  Future<void> login() async {
    var hiveUtil = HiveUtil();

    // 登录，设置 accessToken
    LoginResp loginResp =
        await PersonApi.login(account.value.text, password.value.text);
    hiveUtil.accessToken = loginResp.accessToken;

    // 获取当前用户信息
    TargetResp userInfo = await PersonApi.userInfo();
    await hiveUtil.initEnvParams(userInfo.id);
    await hiveUtil.putValue(Keys.userInfo, userInfo);
    await hiveUtil.putValue(Keys.user, loginResp.user);

    // 更新一下数据库信息
    User user = loginResp.user.toUser();
    await user.upsert();
  }
}
