import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/main.dart';
import 'package:orginone/utils/toast_utils.dart';
import 'package:orginone/components/widgets/loading_dialog.dart';

import '../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class RegisterController extends BaseController<RegisterState> {
  @override
  final RegisterState state = RegisterState();

  void changeAgreeTerms() {
    state.agreeTerms.value = !state.agreeTerms.value;
  }

  void nextStep() {
    if (state.userNameController.text.isEmpty) {
      ToastUtils.showMsg(msg: "请输入用户名");
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

    state.isStepOne.value = false;
  }

  void previousStep() {
    state.isStepOne.value = true;
  }

  void showPassWord() {
    state.passwordUnVisible.value = !state.passwordUnVisible.value;
  }

  void register() async {
    LoadingDialog.showLoading(context);
    var res = await settingCtrl.provider.register(RegisterType(
        nickName: state.nickNameController.text,
        name: state.realNameController.text,
        phone: state.phoneNumberController.text,
        account: state.userNameController.text,
        password: state.passWordController.text,
        motto: state.remarkController.text,
        avatar: ''));
    LoadingDialog.dismiss(context);
    if (res.success) {
      ToastUtils.showMsg(msg: "注册成功,请重新登录");
      Get.back();
    }
  }

  void showVerifyPassWord() {
    state.verifyPassWordUnVisible.value = !state.verifyPassWordUnVisible.value;
  }
}
