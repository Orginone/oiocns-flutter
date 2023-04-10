

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';

class ForgotPasswordState extends BaseGetState{
   TextEditingController accountController = TextEditingController();

   TextEditingController keyController = TextEditingController();

   TextEditingController passWordController = TextEditingController();

   TextEditingController verifyPassWordController = TextEditingController();

   var passwordUnVisible = true.obs;

   var verifyPassWordUnVisible = true.obs;
}