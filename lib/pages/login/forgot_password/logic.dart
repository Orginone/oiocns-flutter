import 'dart:async';

import 'package:get/get.dart';
import 'package:orginone/common/values/constants.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/main_base.dart';
import 'package:orginone/utils/toast_utils.dart';

import '../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class ForgotPasswordController extends BaseController<ForgotPasswordState> {
  @override
  final ForgotPasswordState state = ForgotPasswordState();
  late String _dynamicId = "";
  void showPassWord() {
    state.passwordUnVisible.value = !state.passwordUnVisible.value;
  }

  void showVerifyPassWord() {
    state.verifyPassWordUnVisible.value = !state.verifyPassWordUnVisible.value;
  }

  void submit() async {
    if (state.accountController.text.isEmpty) {
      ToastUtils.showMsg(msg: "请输入用户名");
      return;
    }
    if (state.privateKey.isTrue && state.keyController.text.isEmpty) {
      ToastUtils.showMsg(msg: "请输入注册时保存的账户私钥");
      return;
    }
    if (state.phoneNumber.isTrue && state.verifyController.text.isEmpty) {
      ToastUtils.showMsg(msg: "请输入短信验证码");
      return;
    }
    if (state.passWordController.text != state.verifyPassWordController.text) {
      ToastUtils.showMsg(msg: "输入的两次密码不一致！");
      return;
    }
    if (state.passWordController.text.length < 6) {
      ToastUtils.showMsg(msg: "密码的长度不能小于6");
      return;
    }
    if (state.passWordController.text.length > 15) {
      ToastUtils.showMsg(msg: "密码的长度不能大于15");
      return;
    }
    RegExp regExp =
        RegExp(r'(?=.*[0-9])(?=.*[a-zA-Z])(?=.*[^a-zA-Z0-9]).{6,15}');
    Match? match = regExp.firstMatch(state.passWordController.text);
    if (match == null) {
      ToastUtils.showMsg(msg: '密码必须包含：数字、字母、特殊字符');
      return;
    }
    ResultType result;
    if (state.privateKey.isTrue) {
      result = await relationCtrl.auth.resetPassword(ResetPwdModel(
        account: state.accountController.text,
        password: state.passWordController.text,
        privateKey: state.keyController.text,
      ));
    } else {
      result = await relationCtrl.auth.resetPassword(ResetPwdModel(
        account: state.accountController.text,
        password: state.passWordController.text,
        dynamicId: _dynamicId,
        dynamicCode: state.verifyController.text,
      ));
    }

    if (result.success) {
      ToastUtils.showMsg(msg: '重置密码成功，请重新登录');
      Get.back();
    } else {
      ToastUtils.showMsg(msg: result.msg);
    }
  }

  void backToLoginPage() {
    Get.back();
  }

  void switchMode(int x) {
    if (x == 1) {
      state.privateKey.value = true;
      state.phoneNumber.value = false;
    } else {
      state.privateKey.value = false;
      state.phoneNumber.value = true;
    }
  }

  // 获得动态验证码
  Future<void> getDynamicCode() async {
    RegExp regex = RegExp(Constants.accountRegex);
    if (!regex.hasMatch(state.accountController.text)) {
      ToastUtils.showMsg(msg: "请输入正确的手机号");
      return;
    }
    if (state.sendVerify.value) {
      ToastUtils.showMsg(msg: "验证码已发送，请稍后再试");
      return;
    }
    state.startCountDown.value = true;
    state.countDown.value = 60;
    _dynamicId = '';

    var res = await relationCtrl.auth.dynamicCode(DynamicCodeModel.fromJson({
      'account': state.accountController.text,
      'platName': '资产共享云',
      'dynamicId': '',
    }));
    if (res.success && res.data != null) {
      _dynamicId = res.data!.dynamicId;
      state.sendVerify = true.obs;
      startCountDown();
    }
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
