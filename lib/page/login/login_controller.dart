import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:orginone/api/person_api.dart';
import 'package:orginone/api_resp/target_resp.dart';

import '../../api_resp/login_resp.dart';
import '../../util/hive_util.dart';

class LoginController extends GetxController {
  var account = TextEditingController(text: "15168347908");
  var password = TextEditingController(text: "38179960Jzy~");

  Future<bool> login() async {

    LoginResp loginResp =
        await PersonApi.login(account.value.text, password.value.text);

    // 登录后初始化 box
    var hiveUtil = HiveUtil();
    await hiveUtil.initEnvParams(account.value.text);

    await hiveUtil.putValue(Keys.accessToken, loginResp.accessToken);
    await hiveUtil.putValue(Keys.user, loginResp.user);

    TargetResp userInfo = await PersonApi.userInfo();
    await hiveUtil.putValue(Keys.userInfo, userInfo);

    return true;
  }
}
