import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:orginone/page/home/mine/mine_controller.dart';
import 'package:orginone/routers.dart';

import '../../../component/choose_item.dart';
import '../../../component/icon_avatar.dart';
import '../../../component/unified_edge_insets.dart';
import '../../../component/unified_text_style.dart';

class MinePage extends GetView<MineController> {
  const MinePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ListView(
          shrinkWrap: true,
          children: [_person, _unit, _businessCard, _secure],
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

  get _person => ChooseItem(
        header: const IconAvatar(
          icon: Icon(
            Icons.person,
            color: Colors.white,
          ),
        ),
        body: Container(
          margin: left10,
          child: Text("个人信息", style: text16Bold),
        ),
        func: () {
          Get.toNamed(Routers.mineInfo);
        },
      );

  get _unit => ChooseItem(
        header: const IconAvatar(
          icon: Icon(
            Icons.person,
            color: Colors.white,
          ),
        ),
        body: Container(
          margin: left10,
          child: Text("我的单位", style: text16Bold),
        ),
        func: () {
          Get.toNamed(Routers.mineUnit);
        },
      );

  get _businessCard => ChooseItem(
        header: const IconAvatar(
          icon: Icon(
            Icons.account_box,
            color: Colors.white,
          ),
        ),
        body: Container(
          margin: left10,
          child: Text("我的名片", style: text16Bold),
        ),
        func: () {
          Get.toNamed(Routers.mineCard);
        },
      );

  get _secure => ChooseItem(
        header: const IconAvatar(
          icon: Icon(
            Icons.account_box,
            color: Colors.white,
          ),
        ),
        body: Container(
          margin: left10,
          child: Text("安全设置", style: text16Bold),
        ),
        func: () {
          Get.toNamed(Routers.mineCard);
        },
      );
}
