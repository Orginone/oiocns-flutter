import 'package:get/get.dart';
import 'package:flutter/material.dart';

class Recent {
  final String id;
  final String name;
  final String url;
  Recent(this.id, this.name, this.url);
}

class RecentlyOpenedController extends GetxController {
  RxList recentlyList = [].obs;
  RxInt currentIndex = 0.obs;

  @override
  void onInit() {
    debugPrint('---————————————>recentlycontroller onInit');
    for (var i = 0; i < 7; i++) {
      recentlyList.add(
          Recent("$i", "资产监管", "http://anyinone.com:800/img/logo/logo3.jpg"));
    }
    super.onInit();
  }

  List getList(int index) {
    return index * 5 + 5 > recentlyList.length
        ? recentlyList.sublist(index * 5, recentlyList.length)
        : recentlyList.sublist(index * 5, index * 5 + 5);
  }
}
