import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/core/base/api/app_server.dart';
import 'package:orginone/component/loading_button.dart';
import 'package:orginone/public/image/load_image.dart';

import '../../component/a_font.dart';
import '../../routers.dart';
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
            AImage.localImage("light_logo_vertical", size: Size(200.w, 200.w)),
            Container(
              padding: EdgeInsets.only(left: 40.w, top: 10.w, right: 40.w),
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
              ),
            ),
            Container(
                padding: EdgeInsets.only(left: 40.w, top: 10, right: 40.w),
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
                padding: EdgeInsets.only(left: 40.w, top: 30.h, right: 40.w),
                child: LoadingButton(
                  callback: () async {
                    if (!formKey.currentState!.validate()) return;
                    await controller.login();
                    Get.offNamed(Routers.home);
                  },
                  child: Text("登录", style: AFont.instance.size20WhiteW500),
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
                      child: const Text(
                        '忘记密码',
                        style: TextStyle(
                          color: Colors.lightBlue,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
