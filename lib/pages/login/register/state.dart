

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';

class RegisterState extends BaseGetState{
  var isStepOne = true.obs;
  TextEditingController userNameController = TextEditingController();
  TextEditingController passWordController = TextEditingController();
  TextEditingController verifyPassWordController = TextEditingController();

  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController nickNameController = TextEditingController();
  TextEditingController realNameController = TextEditingController();
  TextEditingController remarkController = TextEditingController();

  var agreeTerms = true.obs;

  var passwordUnVisible = true.obs;
}