import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/config/index.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';

class LoginState extends BaseGetState {
  var accountLogin = true.obs;

  var phoneNumberLogin = false.obs;

  TextEditingController accountController =
      TextEditingController(text: Constant.userName);

  TextEditingController passWordController =
      TextEditingController(text: Constant.pwd);

  TextEditingController phoneNumberController = TextEditingController();

  TextEditingController verifyController = TextEditingController();

  var agreeTerms = true.obs;

  var passwordUnVisible = true.obs;

  var sendVerify = false.obs;
}
