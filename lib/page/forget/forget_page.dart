import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:orginone/page/login/login_controller.dart';
import 'package:orginone/routers.dart';

import '../../api/person_api.dart';
import 'forget_controller.dart';

class ForgetPage extends GetView<ForgetController> {
  const ForgetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ForgetController>(
        init: ForgetController(),
        builder: (item) => Scaffold(
              body: () {
                return const RegistFormWidget1();
              }(),
            ));
  }
}

class RegistFormWidget1 extends GetView<ForgetController> {
  const RegistFormWidget1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    return Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("Orginone", style: TextStyle(fontSize: 50)),
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
                  decoration:
                      const InputDecoration(hintText: '大小写字母和数字符号组合的6-15位密码'),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (TextUtil.isEmpty(value)) {
                      return "密码不能为空!";
                    }
                    value = value ?? '';
                    RegExp exp = RegExp(
                        r"^(?![A-Za-z]+$)(?![A-Z\d]+$)(?![A-Z\W]+$)(?![a-z\d]+$)(?![a-z\W]+$)(?![\d\W]+$)\S{6,15}$");
                    if (!exp.hasMatch(value)) {
                      return '密码格式错误';
                    }
                    return null;
                  },
                )),
            Container(
                padding: const EdgeInsets.fromLTRB(40, 10, 40, 0),
                child: TextFormField(
                  controller: controller.confirmController,
                  decoration: const InputDecoration(hintText: '确认你的密码'),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value != controller.passwordController.text) {
                      return '两次输入密码不一致';
                    }
                    return null;
                  },
                )),
            Container(
                padding: const EdgeInsets.fromLTRB(40, 10, 40, 0),
                child: TextFormField(
                  controller: controller.privateKeyController,
                  decoration: const InputDecoration(hintText: '请输入私钥'),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (TextUtil.isEmpty(value)) {
                      return "私钥不能为空!";
                    }
                    return null;
                  },
                )),
            Container(
                padding: const EdgeInsets.fromLTRB(40, 30, 40, 0),
                child: GFButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      //注册
                      var postData = {
                        "account": controller.accountController.text,
                        "password": controller.passwordController.text,
                        "password2": controller.confirmController.text,
                        "privateKey": controller.privateKeyController.text
                      };
                      await PersonApi.resetPwd(postData);
                      Fluttertoast.showToast(
                          msg: '重置密码成功',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.grey,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      Get.offNamed(Routers.main);
                    }
                  },
                  text: "重置密码",
                  blockButton: true,
                )),
            Container(
                padding: const EdgeInsets.fromLTRB(40, 15, 40, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: const Text('上一步',
                          style: TextStyle(color: Colors.lightBlue)),
                    ),
                  ],
                ))
          ],
        ));
  }
}
