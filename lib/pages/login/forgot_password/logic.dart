import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/util/toast_utils.dart';

import '../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class ForgotPasswordController extends BaseController<ForgotPasswordState> {
  final ForgotPasswordState state = ForgotPasswordState();

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
    if (state.keyController.text.isEmpty) {
      ToastUtils.showMsg(msg: "请输入注册时保存的账户私钥");
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
    var settingCtrl = Get.find<SettingController>();
    ResultType<bool> result = await settingCtrl.resetPassword(
        state.accountController.text,
        state.passWordController.text,
        state.keyController.text);

    if (result.success) {
      ToastUtils.showMsg(msg: '重置密码成功！');
    } else {
      ToastUtils.showMsg(msg: result.msg);
    }
  }
}
