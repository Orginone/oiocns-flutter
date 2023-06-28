import 'package:get/get.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/main.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/local_store.dart';
import 'package:orginone/util/toast_utils.dart';
import 'package:orginone/widget/loading_dialog.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../dart/core/getx/base_controller.dart';
import 'state.dart';

class LoginController extends BaseController<LoginState> {
  final LoginState state = LoginState();

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    if(!kernel.isOnline){
      kernel.start();
    }
    var account = LocalStore.getStore().getStringList("account");
    if (account != null) {
      state.accountController.text = account[0];
      state.phoneNumberController.text = account[0];
      state.passWordController.text = account[1];
    }
  }

  void showPassWord() {
    state.passwordUnVisible.value = !state.passwordUnVisible.value;
  }

  void switchMode() {
    state.accountLogin.value = !state.accountLogin.value;
    state.phoneNumberLogin.value = !state.phoneNumberLogin.value;
  }

  void changeAgreeTerms() {
    state.agreeTerms.value = !state.agreeTerms.value;
  }

  void login() async {
    if (state.accountController.text.isEmpty ||
        state.passWordController.text.isEmpty) {
      ToastUtils.showMsg(msg: "账号或密码不能为空");
      return;
    }
    if (!state.agreeTerms.value) {
      ToastUtils.showMsg(msg: "请同意服务条款与隐私条款");
      return;
    }

    var res = await settingCtrl.provider.login(
      state.accountController.text,
      state.passWordController.text,
    );
    if (res.success) {
      ToastUtils.showMsg(msg: "登录成功");
      [Permission.storage, Permission.notification].request();
      LocalStore.getStore().setStringList("account",
          [state.accountController.text, state.passWordController.text]);
      Get.offAndToNamed(Routers.home);
    } else {
      ToastUtils.showMsg(msg: res.msg);
    }
  }

  void sendVerify() {
    if (state.phoneNumberController.text.length > 11) {
      ToastUtils.showMsg(msg: "请输入正确的手机号");
      return;
    }
    if (!state.agreeTerms.value) {
      ToastUtils.showMsg(msg: "请同意服务条款与隐私条款");
      return;
    }
    Get.toNamed(Routers.verificationCode,
        arguments: {"phoneNumber": state.phoneNumberController.text});
  }

  void forgotPassword() {
    Get.toNamed(Routers.forgotPassword);
  }

  void register() {
    Get.toNamed(
      Routers.register,
    );
  }
}
