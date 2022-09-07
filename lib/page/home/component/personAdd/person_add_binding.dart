import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/page/home/component/personAdd/person_add_controller.dart';

class PersonAddBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PersonAddController());
  }
}