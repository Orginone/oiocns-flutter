import 'dart:async';

import 'package:get/get.dart';
import 'package:orginone/common/routers/index.dart';
import 'package:orginone/common/values/constants.dart';
import 'package:orginone/config/constant.dart';
import 'package:orginone/dart/base/model.dart';
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
    var account = Storage.getList(Constants.account);
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
    allowLogin();
  }

  //是否允许点击登录
  void allowLogin() {
    if (state.accountLogin.value) {
      state.allowCommit = (state.accountController.text.isNotEmpty &&
              state.passWordController.text.isNotEmpty)
          .obs;
    }
    if (state.phoneNumberLogin.value) {
      state.allowCommit = (state.phoneNumberController.text.isNotEmpty &&
              state.verifyController.text.isNotEmpty &&
              state.verifyController.text.length == 6)
          .obs;
    }
    print(
        'account:${state.accountController.text},pwd:${state.passWordController.text.isNotEmpty},allowCommit:${state.allowCommit.value}');
  }

  void showPassWord() {
    state.passwordUnVisible.value = !state.passwordUnVisible.value;
  }

  void switchMode(int x) {
    if (x == 1) {
      state.accountLogin.value = true;
      state.phoneNumberLogin.value = false;
    } else {
      state.accountLogin.value = false;
      state.phoneNumberLogin.value = true;
    }
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
    var res = await relationCtrl.provider.login(
      state.accountController.text,
      state.passWordController.text,
    );
    if (res.success) {
      ToastUtils.showMsg(msg: "登录成功");
      [Permission.storage, Permission.notification].request();
      Storage.setList(Constants.account,
          [state.accountController.text, state.passWordController.text]);

      Get.offAndToNamed(Routers.logintrans, arguments: true);
      Future.delayed(const Duration(seconds: 2));
    } else {
      ToastUtils.showMsg(msg: res.msg ?? '登录失败');
    }
  }

  //验证码登录
  void verifyCodeLogin() async {
    if (state.phoneNumberController.text.isEmpty) {
      ToastUtils.showMsg(msg: "手机号不得为空");
      return;
    }
    if (state.verifyController.text.isEmpty) {
      ToastUtils.showMsg(msg: "验证码不得为空");
      return;
    }

    var res = await relationCtrl.provider.verifyCodeLogin(
        state.phoneNumberController.text,
        state.verifyController.text,
        state.dynamicId.value);
    if (res.success) {
      state.dynamicId = ''.obs;
      ToastUtils.showMsg(msg: "登录成功");
      [Permission.storage, Permission.notification].request();
      Storage.setList(Constants.account,
          [state.accountController.text, state.passWordController.text]);

      Get.offAndToNamed(Routers.logintrans, arguments: true);
      Future.delayed(const Duration(seconds: 2));
    } else {
      ToastUtils.showMsg(msg: res.msg ?? '登录失败');
    }
  }

  void sendVerify() {
    RegExp regex = RegExp(Constants.accountRegex);
    if (!regex.hasMatch(state.phoneNumberController.text)) {
      ToastUtils.showMsg(msg: "请输入正确的手机号");
    }

    if (!state.agreeTerms.value) {
      ToastUtils.showMsg(msg: "请同意服务条款与隐私条款");
      return;
    }
    Get.toNamed(Routers.verificationCode,
        arguments: {"phoneNumber": state.phoneNumberController.text});
  }

  ///验证码登录获取验证码
  Future<void> sendLoginVerify() async {
    RegExp regex = RegExp(Constants.accountRegex);
    if (!regex.hasMatch(state.phoneNumberController.text)) {
      ToastUtils.showMsg(msg: "请输入正确的手机号");
      return;
    }
    if (state.sendVerify.value) {
      ToastUtils.showMsg(msg: "验证码已发送，请稍后再试");
      return;
    }

    state.startCountDown.value = true;
    state.countDown.value = 60;
    state.dynamicId.value = '';
    var res = await relationCtrl.auth.dynamicCode(DynamicCodeModel.fromJson({
      'account': state.phoneNumberController.text,
      'platName': '资产共享云',
      'dynamicId': '',
    }));

    if (res.success && res.data != null) {
      print(
          "获取验证码信息：${res.data!.dynamicId},${res.data!.account},${res.data!.platName}");
      state.dynamicId.value = res.data!.dynamicId;
      state.sendVerify = true.obs;
    }
    startCountDown();
  }

  void forgotPassword(String account) {
    Get.toNamed(Routers.forgotPassword, arguments: {"account": account});
  }

  void register() {
    Get.toNamed(
      Routers.register,
    );
  }

  void startCountDown() {
    if (state.timer != null) {
      if (state.timer!.isActive) {
        timerClose();
      }
    }
    state.timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.countDown.value <= 0) {
        timerClose();
      }
      state.countDown.value--;
    });
  }

  void timerClose() {
    state.timer?.cancel();
    state.timer = null;
    state.startCountDown.value = false;
    state.countDown.value = 60;
    state.sendVerify.value = false;
  }
}
