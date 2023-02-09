import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/components/loading_button.dart';
import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/util/load_image.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _form());
  }

  Widget _form() {
    var formKey = GlobalKey<FormState>();
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[_logo, _account, _password, _loginBtn(formKey)],
      ),
    );
  }

  get _logo {
    return AImage.localImage("light_logo_vertical", size: Size(200.w, 200.w));
  }

  get _account {
    return Container(
      padding: EdgeInsets.only(left: 40.w, top: 10.h, right: 40.w),
      child: TextFormField(
        controller: controller.accountCtrl,
        decoration: const InputDecoration(hintText: '请输入账号'),
        validator: (value) => TextUtil.isEmpty(value) ? "账号不能为空!" : null,
      ),
    );
  }

  get _password {
    return Container(
      padding: EdgeInsets.only(left: 40.w, top: 10.h, right: 40.w),
      child: TextFormField(
        controller: controller.passwordCtrl,
        decoration: const InputDecoration(hintText: '请输入密码'),
        validator: (value) => TextUtil.isEmpty(value) ? "账号不能为空!" : null,
      ),
    );
  }

  Widget _loginBtn(GlobalKey<FormState> formKey) {
    return Container(
      padding: EdgeInsets.only(left: 40.w, top: 10.h, right: 40.w),
      child: LoadingButton(
        loadingBtnCtrl: LoadingButtonController(),
        callback: () async {
          if (!formKey.currentState!.validate()) return;
          await controller.login();
        },
        child:
            Text("登录", style: TextStyle(fontSize: 20.sp, color: Colors.white),),
      ),
    );
  }
}

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
  }
}

class LoginController extends GetxController {
  final Logger log = Logger("LoginController");

  final accountCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  login() async {
    var account = accountCtrl.value.text;
    var password = passwordCtrl.value.text;

    var res = await KernelApi.getInstance().login(account, password);
    log.info(res.data);
  }
}
