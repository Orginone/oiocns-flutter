import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:orginone/util/any_store_util.dart';

import '../../routers.dart';
import '../../util/hub_util.dart';
import 'login_controller.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();

    return Scaffold(
        body: Form(
            key: formKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text("Orginone", style: TextStyle(fontSize: 50)),
                  Container(
                      margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: const Text("奥集能", style: TextStyle(fontSize: 30))),
                  Container(
                      padding: const EdgeInsets.fromLTRB(40, 10, 40, 0),
                      child: TextFormField(
                        controller: controller.accountController,
                        decoration: const InputDecoration(hintText: '请输入账号'),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (TextUtil.isEmpty(value)) {
                            return "账号不能为空!";
                          }
                          return null;
                        },
                      )),
                  Container(
                      padding: const EdgeInsets.fromLTRB(40, 10, 40, 0),
                      child: TextFormField(
                        controller: controller.passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: '请输入密码',
                        ),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (TextUtil.isEmpty(value)) {
                            return "密码不能为空!";
                          }
                          return null;
                        },
                      )),
                  Container(
                      padding: const EdgeInsets.fromLTRB(40, 30, 40, 0),
                      child: GFButton(
                        onPressed: () async {
                          if (!formKey.currentState!.validate()) return;

                          // 登录以及连接聊天服务器
                          await controller.login();
                          await HubUtil().tryConn();
                          await AnyStoreUtil().tryConn();

                          Get.offNamed(Routers.home);
                        },
                        text: "登录",
                        blockButton: true,
                      )),
                  Container(
                      padding: const EdgeInsets.fromLTRB(40, 15, 40, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(Routers.register);
                            },
                            child: const Text('注册',
                                style: TextStyle(color: Colors.lightBlue)),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(Routers.forget);
                            },
                            child: Container(
                                margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                child: const Text('忘记密码',
                                    style: TextStyle(
                                      color: Colors.lightBlue,
                                    ))),
                          )
                        ],
                      )),
                ])));
  }
}
