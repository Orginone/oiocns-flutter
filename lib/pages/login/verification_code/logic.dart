import 'dart:async';

import '../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class VerificationCodeController extends BaseController<VerificationCodeState> {
  @override
  final VerificationCodeState state = VerificationCodeState();

  @override
  void onReady() {
    super.onReady();
    startCountDown();
  }

  void verification(String code) {
    if (code.length == 6) {
      state.verificationDone.value = true;
      state.hasError = true;
    } else {
      state.verificationDone.value = false;
      state.hasError = false;
    }
  }

  void resend() {
    state.startCountDown.value = true;
    state.countDown.value = 60;
    startCountDown();
  }

  void startCountDown() {
    if (state.timer != null) {
      if (state.timer!.isActive) {
        timerClose();
      }
    }
    state.timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.countDown.value <= 0) {
        timerClose();
        state.startCountDown.value = false;
      }
      state.countDown.value--;
    });
  }

  void timerClose() {
    state.timer?.cancel();
    state.timer = null;
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    timerClose();
  }
}
