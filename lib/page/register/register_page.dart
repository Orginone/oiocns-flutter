import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:orginone/page/register/register_controller.dart';

class RegisterPage extends GetView<RegisterController> {
  const RegisterPage({Key? key}) : super(key: key);

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
                    controller: controller.phoneController,
                    decoration: const InputDecoration(hintText: '请输入电话号码'),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (TextUtil.isEmpty(value)) {
                        return "电话号码不能为空!";
                      }
                      return null;
                    },
                  )),
              Container(
                  padding: const EdgeInsets.fromLTRB(40, 10, 40, 0),
                  child: TextFormField(
                    controller: controller.nicknameController,
                    decoration: const InputDecoration(hintText: '请输入昵称'),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (TextUtil.isEmpty(value)) {
                        return "昵称不能为空!";
                      }
                      return null;
                    },
                  )),
              Container(
                  padding: const EdgeInsets.fromLTRB(40, 10, 40, 0),
                  child: TextFormField(
                    controller: controller.usernameController,
                    decoration: const InputDecoration(hintText: '请输入真实名称'),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (TextUtil.isEmpty(value)) {
                        return "真实名称不能为空!";
                      }
                      return null;
                    },
                  )),
              Container(
                  padding: const EdgeInsets.fromLTRB(40, 10, 40, 0),
                  child: TextFormField(
                    controller: controller.mottoController,
                    decoration: const InputDecoration(hintText: '请输入座右铭'),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (TextUtil.isEmpty(value)) {
                        return "座右铭不能为空!";
                      }
                      return null;
                    },
                  )),
              Container(
                  padding: const EdgeInsets.fromLTRB(40, 10, 40, 0),
                  child: TextFormField(
                    controller: controller.accountController,
                    decoration: const InputDecoration(hintText: '请输入账户'),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (TextUtil.isEmpty(value)) {
                        return "账户不能为空!";
                      }
                      return null;
                    },
                  )),
              Container(
                  padding: const EdgeInsets.fromLTRB(40, 10, 40, 0),
                  child: TextFormField(
                    controller: controller.passwordController,
                    decoration: const InputDecoration(
                        hintText: '以大小写字母和数字符号组合的6-15位新密码'),
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
                    onPressed: () async {},
                    text: "下一步",
                    blockButton: true,
                  ))
            ],
          )),
    );
  }
}
