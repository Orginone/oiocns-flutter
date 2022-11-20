import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/api/person_api.dart';
import 'package:orginone/api/store_server.dart';
import 'package:orginone/api_resp/login_resp.dart';
import 'package:orginone/component/loading_button.dart';
import 'package:orginone/logic/authority.dart';
import 'package:orginone/api/chat_server.dart';

class LoginController extends GetxController {
  Logger log = Logger("LoginController");

  var accountController = TextEditingController();
  var passwordController = TextEditingController();
  var loginBtnController = LoadingButtonController();

  Future<void> login() async {
    // 登录，设置 accessToken
    var account = accountController.value.text;
    var password = passwordController.value.text;

    LoginResp loginResp = await PersonApi.login(account, password);
    setAccessToken = loginResp.accessToken;

    // 获取当前用户信息
    await loadAuth();

    // 连接服务器
    try {
      await storeServer.start();
      await chatServer.start();
    } catch (error) {
      log.info("====> ${error.toString()}");
    }
  }
}
