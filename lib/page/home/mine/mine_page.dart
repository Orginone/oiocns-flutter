import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/component/choose_item_type1.dart';
import 'package:orginone/page/home/mine/mine_controller.dart';
import 'package:orginone/routers.dart';

class MinePage extends GetView<MineController> {
  const MinePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ChooseItemType1(Icons.person, "个人信息", () {
          Get.toNamed(Routers.mineInfo);
        }),
        ChooseItemType1(Icons.group, "我的单位", () {
          Get.toNamed(Routers.mineUnit);
        }),
        ChooseItemType1(Icons.account_box, "我的名片", () {
          Get.toNamed(Routers.mineCard);
        }),
        ChooseItemType1(Icons.group_add_sharp, "安全设置", () {})
      ],
    );
  }
}
