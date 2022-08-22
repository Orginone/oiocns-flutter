import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CzhController extends GetxController {
  TextEditingController searchGroupText = TextEditingController();
  var textField1 = 1.obs;
  var textField2 = 2.obs;
  void test1(a) {
    textField1.value = a;
  }
}