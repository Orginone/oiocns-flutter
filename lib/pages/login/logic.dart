import 'package:get/get.dart';
import 'package:orginone/common/routers/index.dart';
import 'package:orginone/config/constant.dart';
import 'package:orginone/main.dart';
import 'package:orginone/utils/storage.dart';
import 'package:orginone/utils/toast_utils.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../dart/core/getx/base_controller.dart';
import 'state.dart';

class LoginController extends BaseController<LoginState> {
  @override
  final LoginState state = LoginState();

  @override
  void onInit() async {
    super.onInit();
    // if (!kernel.isOnline) {
    //   kernel.start();
    // }
    var account = Storage.getList("account");
    if (account.isNotEmpty) {
      state.accountController.text = account.first;
      state.phoneNumberController.text = account.first;
      state.passWordController.text =
          "" != account.last ? account.last : Constant.pwd;
    } else {
      state.accountController.text = Constant.userName;
      state.phoneNumberController.text = Constant.userName;
      state.passWordController.text = Constant.pwd;
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
      Storage.setList("account",
          [state.accountController.text, state.passWordController.text]);

      Get.offAndToNamed(Routers.logintrans, arguments: true);
      Future.delayed(const Duration(seconds: 2));
    } else {
      ToastUtils.showMsg(msg: res.msg ?? '登录失败');
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
