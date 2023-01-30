import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/pages/home/component/person_add/person_add_controller.dart';

class PersonAddBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PersonAddController());
  }
}