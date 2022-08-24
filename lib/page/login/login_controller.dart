import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:orginone/api/person_api.dart';
import 'package:orginone/api_resp/target_resp.dart';

import '../../api/company_api.dart';
import '../../api_resp/login_resp.dart';
import '../../model/db_model.dart';
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

    // 更新一下数据库信息
    User user = loginResp.user.toUser();
    await user.upsert();

    // 个人空间, 公司空间
    TargetResp userInfo = await PersonApi.userInfo();
    List<dynamic> companys = await CompanyApi.getJoinedCompanys(0, 100);

    List<TargetResp> convertedCompany = [];
    convertedCompany.add(userInfo);
    for (var company in companys) {
      convertedCompany.add(TargetResp.fromMap(company));
    }
    await hiveUtil.putValue(Keys.userInfo, userInfo);
    await hiveUtil.putValue(Keys.companys, convertedCompany);

    // 更新这些空间
    for (TargetResp company in convertedCompany) {
      await company.toTarget().upsert();
      await UserSpaceRelation(account: user.account, targetId: company.id, name: company.name, isExpand: true).upsert();
    }

    return true;
  }
}
