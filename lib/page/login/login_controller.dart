import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/api/person_api.dart';
import 'package:orginone/api_resp/login_resp.dart';
import 'package:orginone/component/loading_button.dart';
import 'package:orginone/logic/authority.dart';
import 'package:orginone/logic/server/chat_server.dart';
import 'package:orginone/logic/server/store_server.dart';
import 'package:orginone/util/hive_util.dart';

class LoginController extends GetxController {
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
    var hiveUtil = HiveUtil();

    // 登录，设置 accessToken
    var account = accountController.value.text;
    var password = passwordController.value.text;

    LoginResp loginResp = await PersonApi.login(account, password);
    hiveUtil.accessToken = loginResp.accessToken;

    //存储账号密码历史数据
    await HiveUtil().uniqueBox.put('historyLogin', {
      'account': account,
      'password': password,
    });

    // 获取当前用户信息
    await loadAuth();

    // 连接服务器
    await storeServer.start();
    await chatServer.start();
  }
}
