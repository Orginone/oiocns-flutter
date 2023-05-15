


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';

class LoginState extends BaseGetState{

  var accountLogin = true.obs;

  var phoneNumberLogin = false.obs;

  TextEditingController accountController = TextEditingController(text: "14779924498");

  TextEditingController passWordController = TextEditingController(text: "@Shen0813");

  TextEditingController phoneNumberController = TextEditingController();

  TextEditingController verifyController = TextEditingController();

  var agreeTerms = true.obs;

  var passwordUnVisible = true.obs;

  var sendVerify = false.obs;

}