import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:orginone/components/widgets/loading_button.dart';
import 'package:orginone/dart/controller/setting/index.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/load_image.dart';
import 'package:orginone/util/local_store.dart';
import 'package:permission_handler/permission_handler.dart';

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
        children: <Widget>[
          _logo,
          _account,
          _password,
          _loginBtn(formKey),
        ],
      ),
    );
  }

  get _logo {
    return XImage.localImage("light_logo_vertical", size: Size(200.w, 200.w));
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
        obscureText: true,
        controller: controller.passwordCtrl,
        decoration: const InputDecoration(hintText: '请输入密码'),
        validator: (value) => TextUtil.isEmpty(value) ? "账号不能为空!" : null,
      ),
    );
  }

  Widget _loginBtn(GlobalKey<FormState> formKey) {
    return Container(
      padding: EdgeInsets.only(left: 40.w, top: 16.h, right: 40.w),
      child: LoadingButton(
        loadingBtnCtrl: LoadingButtonController(),
        callback: () async {
          if (!formKey.currentState!.validate()) return;
          var settingCtrl = Get.find<SettingController>();
          var res = await settingCtrl.login(controller.accountCtrl.text, controller.passwordCtrl.text);
          if (res.success) {
            [Permission.storage, Permission.notification].request();
            Get.toNamed(Routers.home);
          } else {
            Fluttertoast.showToast(msg: res.msg);
          }
        },
        child: Text(
          "登录",
          style: TextStyle(fontSize: 20.sp, color: Colors.white),
        ),
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
  final accountCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  @override
  void onInit() async {
    var store = await LocalStore.instance;
    var account = store.getStringList("account");
    if (account != null){
      accountCtrl.text = account[0];
      passwordCtrl.text = account[1];
    }
    super.onInit();
  }
}
