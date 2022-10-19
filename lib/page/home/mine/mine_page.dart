import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:orginone/component/choose_item_type1.dart';
import 'package:orginone/page/home/mine/mine_controller.dart';
import 'package:orginone/routers.dart';

class MinePage extends GetView<MineController> {
  const MinePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ListView(
          shrinkWrap: true,
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
        ),
        Container(
          margin: EdgeInsets.only(left: 20.w, bottom: 10.h, right: 20.w),
          child: GFButton(
            onPressed: () async {
              Get.offAllNamed(Routers.main);
            },
            color: Colors.redAccent,
            text: "注销",
            blockButton: true,
          ),
        )
      ],
    );
  }
}
