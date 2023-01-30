import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/core/base/api/kernelapi.dart';
import 'package:orginone/api_resp/login_resp.dart';
import 'package:orginone/components/loading_button.dart';
import 'package:orginone/core/authority.dart';
import 'package:orginone/util/hive_util.dart';

class LoginController extends GetxController {
  Logger log = Logger("LoginController");

  var accountController = TextEditingController();
  var passwordController = TextEditingController();
  var loginBtnController = LoadingButtonController();

  @override
  onInit() {
    super.onInit();
    initLogin();
  }

  initLogin() {
    var historyLogin = HiveUtil().uniqueBox.get("historyLogin");
    accountController.text = historyLogin?["account"] ?? "";
    passwordController.text = historyLogin?["password"] ?? "";
    update();
  }

  Future<void> login() async {
    // 登录，设置 accessToken
    var account = accountController.value.text;
    var password = passwordController.value.text;

    LoginResp loginResp = await Kernel.getInstance.login(account, password);
    setAccessToken = loginResp.accessToken;

    //存储账号密码历史数据
    await HiveUtil().uniqueBox.put('historyLogin', {
      'account': account,
      'password': password,
    });

    // 获取当前用户信息
    await loadAuth();

    // 启动服务
    await Kernel.getInstance.start();
  }
}
