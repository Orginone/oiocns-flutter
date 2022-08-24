import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'czh_controller.dart';

class CzhPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CzhController());
  }
}
