import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';

class LoginState extends BaseGetState {
  var accountLogin = true.obs;

  var phoneNumberLogin = false.obs;

  TextEditingController accountController = TextEditingController(text: "");

  TextEditingController passWordController = TextEditingController(text: "");

  TextEditingController phoneNumberController = TextEditingController();

  TextEditingController verifyController = TextEditingController();

  RxString dynamicId = ''.obs;

  var agreeTerms = true.obs;

  var passwordUnVisible = true.obs;

  //是够允许点击登录
  var allowCommit = false.obs;

  var sendVerify = false.obs;

  //验证码输入完成状态
  // var verificationDone = false.obs;
  //验证码重置时间
  var countDown = 60.obs;
  //开始计时
  var startCountDown = false.obs;

  Timer? timer;
}
