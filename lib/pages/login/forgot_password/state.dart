import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';

class ForgotPasswordState extends BaseGetState {
  TextEditingController accountController = TextEditingController();

  TextEditingController keyController = TextEditingController();
  TextEditingController verifyController = TextEditingController();

  TextEditingController passWordController = TextEditingController();

  TextEditingController verifyPassWordController = TextEditingController();

  var passwordUnVisible = true.obs;

  var verifyPassWordUnVisible = true.obs;

  var privateKey = true.obs;

  var phoneNumber = false.obs;

  //右滑返回
  double distance = 0;

  var sendVerify = false.obs;

  Timer? timer;

  RxString dynamicId = ''.obs;
  //验证码重置时间
  var countDown = 60.obs;
  //开始计时
  var startCountDown = false.obs;

  ForgotPasswordState() {
    accountController.text = Get.arguments['account'];
  }
}
