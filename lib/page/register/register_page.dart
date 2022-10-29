import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:orginone/api/person_api.dart';
import 'package:orginone/page/login/login_controller.dart';
import 'package:orginone/page/register/register_controller.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/hive_util.dart';

class RegisterPage extends GetView<RegisterController> {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterController>(
        init: RegisterController(),
        builder: (item) => Scaffold(
              body: () {
                switch (controller.step) {
                  case 1:
                    return const RegistFormWidget1();
                  case 2:
                    return const RegistFormWidget2();
                  case 3:
                    return const RegistFormWidget3();
                }
              }(),
            ));
  }
}

class RegistFormWidget1 extends GetView<RegisterController> {
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
                margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: const Text("奥集能", style: TextStyle(fontSize: 30))),
            Container(
                padding: const EdgeInsets.fromLTRB(40, 10, 40, 0),
                child: TextFormField(
                  controller: controller.phoneController,
                  decoration: const InputDecoration(hintText: '请输入手机号'),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (TextUtil.isEmpty(value)) {
                      return "手机号不能为空!";
                    }
                    value = value ?? '';
                    //用户名正则，4到16位（字母，数字，下划线，减号）
                    RegExp exp = RegExp(
                        r"^((13[0-9])|(14[5|7])|(15([0-3]|[5-9]))|(18[0,5-9]))\d{8}$");
                    if (!exp.hasMatch(value)) {
                      return '手机号格式错误';
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
                padding: const EdgeInsets.fromLTRB(40, 30, 40, 0),
                child: GFButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      controller.changeStep(2);
                    }
                  },
                  text: "下一步",
                  blockButton: true,
                ))
          ],
        ));
  }
}

class RegistFormWidget2 extends GetView<RegisterController> {
  const RegistFormWidget2({Key? key}) : super(key: key);

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
                padding: const EdgeInsets.fromLTRB(40, 30, 40, 0),
                child: GFButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      //注册
                      var postData = {
                        "account": controller.accountController.text,
                        "motto": controller.mottoController.text,
                        "name": controller.usernameController.text,
                        "nickName": controller.nicknameController.text,
                        "password": controller.passwordController.text,
                        "password2": controller.confirmController.text,
                        "phone": controller.phoneController.text
                      };
                      Map<String, dynamic> res =
                          await PersonApi.register(postData);
                      Fluttertoast.showToast(
                          msg: '注册成功',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.grey,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      //存储账号密码历史数据
                      await HiveUtil().uniqueBox.put('historyLogin', {
                        'account': controller.accountController.text,
                        'password': controller.passwordController.text,
                      });
                      controller.privateKey = res["privateKey"];
                      controller.changeStep(3);
                    }
                  },
                  text: "注册",
                  blockButton: true,
                )),
            Container(
                padding: const EdgeInsets.fromLTRB(40, 15, 40, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller.changeStep(1);
                      },
                      child: const Text('上一步',
                          style: TextStyle(color: Colors.lightBlue)),
                    ),
                    Row(
                      children: [
                        const Text('已有账户?'),
                        GestureDetector(
                          onTap: () {
                            Get.offNamed(Routers.main);
                          },
                          child: const Text('立即登录',
                              style: TextStyle(color: Colors.lightBlue)),
                        )
                      ],
                    )
                  ],
                ))
          ],
        ));
  }
}

class RegistFormWidget3 extends GetView<RegisterController> {
  const RegistFormWidget3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text("Orginone", style: TextStyle(fontSize: 50)),
        Container(
            padding: const EdgeInsets.fromLTRB(40, 60, 40, 0),
            child: SelectableText(
              controller.privateKey,
              style: const TextStyle(fontSize: 31),
            )),
        Container(
            padding: const EdgeInsets.fromLTRB(40, 15, 40, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('该私钥用于账号密码的找回,请及时复制保存'),
                  ],
                )
              ],
            )),
        Container(
            padding: const EdgeInsets.fromLTRB(40, 30, 40, 0),
            child: GFButton(
              onPressed: () async {
                LoginController loginController = Get.find<LoginController>();
                loginController.initLogin();
                Get.offNamed(Routers.main);
              },
              text: "完成",
              blockButton: true,
            )),
      ],
    );
  }
}
