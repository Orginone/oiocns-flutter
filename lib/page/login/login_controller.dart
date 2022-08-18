import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:orginone/api/person_api.dart';
import 'package:orginone/api_resp/target_resp.dart';

import '../../api/company_api.dart';
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

    List<TargetResp> convertedCompany = [];

    // 个人空间
    TargetResp userInfo = await PersonApi.userInfo();
    convertedCompany.add(userInfo);
    await hiveUtil.putValue(Keys.userInfo, userInfo);

    // 公司
    List<dynamic> companys = await CompanyApi.getJoinedCompanys(0, 10);
    for (var company in companys) {
      convertedCompany.add(TargetResp.fromMap(company));
    }
    await hiveUtil.putValue(Keys.companys, convertedCompany);

    return true;
  }
}
