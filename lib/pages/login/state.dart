


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';

class LoginState extends BaseGetState{

  var accountLogin = true.obs;

  var phoneNumberLogin = false.obs;

  TextEditingController accountController = TextEditingController(text: "13322223333");

  TextEditingController passWordController = TextEditingController(text: "38179960Jzy~");

  TextEditingController phoneNumberController = TextEditingController();

  TextEditingController verifyController = TextEditingController();

  var agreeTerms = true.obs;

  var passwordUnVisible = true.obs;

  var sendVerify = false.obs;

}