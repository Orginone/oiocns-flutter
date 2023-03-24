import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/routers.dart';

class Recent {
  final String id;
  final String name;
  final String url;
  final VoidCallback? onTap;

  Recent(this.id, this.name, this.url, this.onTap);
}

class OftenUseController extends GetxController {
  RxList oftenUseList = [].obs;

  @override
  void onInit() {
    debugPrint('---————————————>oftencontroller onInit');
    oftenUseList.add(Recent(
        "0",
        "应用",
        "http://anyinone.com:888/img/logo/logo3.jpg",
        () => Get.toNamed(Routers.application)));
    oftenUseList.add(
        Recent("1", "文件", "http://anyinone.com:888/img/logo/logo3.jpg", () {}));
    oftenUseList.add(
        Recent("2", "资源", "http://anyinone.com:888/img/logo/logo3.jpg", () {}));
    oftenUseList.add(
        Recent("3", "数据", "http://anyinone.com:888/img/logo/logo3.jpg", () {}));
    oftenUseList.add(Recent(
        "4",
        "实体",
        "http://anyinone.com:888/img/logo/logo3.jpg",
        () => Get.toNamed(Routers.choiceGb, arguments: {
              "showChoice": false,
              "showFunctionButton": true,
              "head": "实体",
              "showSearch": false
            })));
    super.onInit();
  }
}
