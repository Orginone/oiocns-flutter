import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:orginone/api/company_api.dart';
import 'package:orginone/model/db_model.dart';
import 'package:orginone/page/home/message/message_controller.dart';

import '../../routers.dart';
import '../../util/hive_util.dart';
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
                        controller: controller.account,
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
                        controller: controller.password,
                        decoration: const InputDecoration(hintText: '请输入密码'),
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
                          await HubUtil().conn();

                          // 连接成功后初始化聊天面板信息，
                          var messageController = Get.find<MessageController>();
                          await messageController.firstInitChartsData();
                          await messageController.initChats();

                          Get.toNamed(Routers.home);
                        },
                        text: "登录",
                        blockButton: true,
                      )),
                ])));
  }
}
