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
    for (var i = 0; i < 1; i++) {
      oftenUseList.add(
          Recent("$i", "资产内控", "http://anyinone.com:888/img/logo/logo3.jpg"));
    }
    super.onInit();
  }
}
