import 'package:get/get.dart';
import 'package:flutter/material.dart';

class Recent {
  final String id;
  final String name;
  final String url;
  Recent(this.id, this.name, this.url);
}

class OftenUseController extends GetxController {
  RxList oftenUseList = [].obs;

  @override
  void onInit() {
    debugPrint('---————————————>oftencontroller onInit');
    for (var i = 0; i < 24; i++) {
      oftenUseList.add(
          Recent("$i", "资产监管", "http://anyinone.com:800/img/logo/logo3.jpg"));
    }
    super.onInit();
  }
}
