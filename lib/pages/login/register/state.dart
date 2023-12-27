import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';

class RegisterState extends BaseGetState {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passWordController = TextEditingController();
  TextEditingController verifyPassWordController = TextEditingController();

  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController dynamicCodeController = TextEditingController();
  TextEditingController nickNameController = TextEditingController();
  TextEditingController realNameController = TextEditingController();
  TextEditingController remarkController = TextEditingController();

  var agreeTerms = true.obs;

  var passwordUnVisible = true.obs;

  var verifyPassWordUnVisible = true.obs;

  //右滑返回
  double distance = 0;

  //是够允许点击登录
  var allowCommit = false.obs;

  var sendVerify = false.obs;

  RxString dynamicId = ''.obs;
  //验证码重置时间
  var countDown = 60.obs;
  //开始计时
  var startCountDown = false.obs;

  Timer? timer;
}
