

import 'dart:async';

import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';

class VerificationCodeState extends BaseGetState{
  late String phoneNumber;

  var hasError = false;

  var verificationDone = false.obs;

  var countDown = 60.obs;

  var startCountDown = true.obs;

  Timer? timer;

  VerificationCodeState(){
    phoneNumber = Get.arguments['phoneNumber'];
  }
}