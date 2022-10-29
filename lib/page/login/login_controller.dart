import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:orginone/api/person_api.dart';
import 'package:orginone/api_resp/target_resp.dart';
import 'package:orginone/component/loading_button.dart';

import '../../api_resp/login_resp.dart';
import '../../logic/authority.dart';
import '../../util/any_store_util.dart';
import '../../util/hive_util.dart';
import '../../util/hub_util.dart';

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
    await AnyStoreUtil().tryConn();
    await HubUtil().tryConn();
  }
}
