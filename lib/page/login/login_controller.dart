import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:orginone/api/person_api.dart';
import 'package:orginone/api_resp/target_resp.dart';

import '../../api_resp/login_resp.dart';
import '../../util/hive_util.dart';

class LoginController extends GetxController {
  // var account = TextEditingController(text: "15168347908");
  // var password = TextEditingController(text: "38179960Jzy~");
  var accountController = TextEditingController();
  var passwordController = TextEditingController();
  @override
  onInit() {
    initLogin();
    super.onInit();
  }

  initLogin() {
    accountController.text = HiveUtil().uniqueBox.get("historyLogin") != null ? HiveUtil().uniqueBox.get("historyLogin")["account"] : '';
    passwordController.text = HiveUtil().uniqueBox.get("historyLogin") != null ? HiveUtil().uniqueBox.get("historyLogin")["password"] : '';
    update();
  }

  Future<void> login() async {
    var hiveUtil = HiveUtil();

    // 登录，设置 accessToken
    LoginResp loginResp =
        await PersonApi.login(accountController.value.text, passwordController.value.text);

    //存储账号密码历史数据
    await HiveUtil().uniqueBox.put('historyLogin', {
      'account': accountController.value.text,
      'password': passwordController.value.text,
    });

    hiveUtil.accessToken = loginResp.accessToken;

    // 获取当前用户信息
    TargetResp userInfo = await PersonApi.userInfo();
    await hiveUtil.initEnvParams(userInfo.id);
    await hiveUtil.putValue(Keys.userInfo, userInfo);
    await hiveUtil.putValue(Keys.user, loginResp.user);
  }
}
