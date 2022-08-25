import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'message_setting_controller.dart';

class MessageSettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MessageSettingController());
  }
}
