import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ApplyIteam {
  String imageUrl;
  String name;
  String versionNumber;
  String message;
  ApplyIteam.formMap(Map<String, dynamic> json)
      : imageUrl = json['111'] ?? "http://anyinone.com:800/img/logo/logo3.jpg",
        name = json['111'] ?? "资产监管",
        versionNumber = json['111'] ?? "资产监管",
        message = json['111'] ?? "资产监管" * 10;
}

class MarketController extends GetxController {
  RxList applyList = [].obs;
  RxInt classificationIndex = 0.obs;
  @override
  void onInit() {
    debugPrint('---————————————>MarketController onInit');
    for (var i = 0; i < 10; i++) {
      applyList.add(ApplyIteam.formMap({}));
    }
    super.onInit();
  }
}
