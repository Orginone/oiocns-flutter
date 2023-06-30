


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';

class LoginState extends BaseGetState{

  var accountLogin = true.obs;

  var phoneNumberLogin = false.obs;

  TextEditingController accountController = TextEditingController(text: "17605871160");

  TextEditingController passWordController = TextEditingController(text: "Xy756912242..");

  TextEditingController phoneNumberController = TextEditingController();

  TextEditingController verifyController = TextEditingController();

  var agreeTerms = true.obs;

  var passwordUnVisible = true.obs;

  var sendVerify = false.obs;
}