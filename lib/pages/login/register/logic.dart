import 'dart:async';

import 'package:get/get.dart';
import 'package:orginone/config/location.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/main.dart';
import 'package:orginone/utils/toast_utils.dart';
import 'package:orginone/components/widgets/loading_dialog.dart';

import '../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class RegisterController extends BaseController<RegisterState> {
  @override
  final RegisterState state = RegisterState();
  final IResources resources = getResouces();
  // 验证码动态密码ID
  late String _dynamicId = "";

  void changeAgreeTerms() {
    state.agreeTerms.value = !state.agreeTerms.value;
  }

  bool regExp(String regStr, String txt) {
    RegExp regExp = RegExp(regStr);
    Match? match = regExp.firstMatch(txt);

    return match == null;
  }

  bool validate() {
    if (!checkPhoneNumber()) {
      return false;
    }
    if (regExp(r'(\d{6})', state.dynamicCodeController.text)) {
      ToastUtils.showMsg(msg: '请输入正确的验证码');
      return false;
    }
    if (state.passWordController.text != state.verifyPassWordController.text) {
      ToastUtils.showMsg(msg: "输入的两次密码不一致！");
      return false;
    }
    if (state.passWordController.text.length < 6) {
      ToastUtils.showMsg(msg: "密码的长度不能小于6");
      return false;
    }
    if (state.passWordController.text.length > 15) {
      ToastUtils.showMsg(msg: "密码的长度不能大于15");
      return false;
    }
    if (regExp(r'(?=.*[0-9])(?=.*[a-zA-Z])(?=.*[^a-zA-Z0-9]).{6,15}',
        state.passWordController.text)) {
      ToastUtils.showMsg(msg: '密码必须包含：数字、字母、特殊字符');
      return false;
    }
    if (regExp(r'^[\u4e00-\u9fa5]{2,8}$', state.userNameController.text)) {
      ToastUtils.showMsg(msg: "请输入正确的姓名");
      return false;
    }
    if (state.remarkController.text.isEmpty) {
      ToastUtils.showMsg(msg: "请输入正确的座右铭");
      return false;
    }
    return true;
  }

  bool checkPhoneNumber() {
    if (state.phoneNumberController.text.isEmpty) {
      ToastUtils.showMsg(msg: "请输入手机号");
      return false;
    } else if (regExp(r'(^1[3|4|5|7|8|9]\d{9}$)|(^09\d{8}$)',
        state.phoneNumberController.text)) {
      ToastUtils.showMsg(msg: "请输入正确的手机号");
      return false;
    }

    return true;
  }

  // 获得动态验证码
  Future<void> getDynamicCode() async {
    RegExp regex = RegExp(r'(^1[3|4|5|7|8|9]\d{9}$)|(^09\d{8}$)');
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
    _dynamicId = '';

    var res = await settingCtrl.auth.dynamicCode(DynamicCodeModel.fromJson({
      'account': state.phoneNumberController.text,
      'platName': resources.platName,
      'dynamicId': '',
    }));
    if (res.success && res.data != null) {
      _dynamicId = res.data!.dynamicId;
      print(
          "获取验证码信息：${res.data!.dynamicId},${res.data!.account},${res.data!.platName}");
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

  // 注册
  void register() async {
    if (!validate()) return;

    LoadingDialog.showLoading(context);
    var res = await settingCtrl.auth.register(RegisterModel(
      account: state.phoneNumberController.text,
      dynamicId: _dynamicId,
      dynamicCode: state.dynamicCodeController.text,
      password: state.passWordController.text,
      name: state.userNameController.text,
      remark: state.remarkController.text,
    ));
    LoadingDialog.dismiss(context);
    if (res.success) {
      ToastUtils.showMsg(msg: "注册成功,请重新登录");
      Get.back();
    } else {
      ToastUtils.showMsg(msg: res.msg);
    }
  }

  void showPassWord() {
    state.passwordUnVisible.value = !state.passwordUnVisible.value;
  }

  void showVerifyPassWord() {
    state.verifyPassWordUnVisible.value = !state.verifyPassWordUnVisible.value;
  }

  void backToLoginPage() {
    Get.back();
  }
}
