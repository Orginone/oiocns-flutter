import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/components/choose_item.dart';
import 'package:orginone/components/icon_avatar.dart';
import 'package:orginone/components/unified_edge_insets.dart';
import 'package:orginone/components/unified_text_style.dart';
import 'package:orginone/dart/core/authority.dart';
import 'package:orginone/pages/setting/mine/mine_controller.dart';
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
            _person,
            _unit,
            _businessCard,
            _secure,
            if (auth.isMobileAPKAdmin([auth.userId])) _uploadAPK
          ],
        ),
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

  get _uploadAPK => ChooseItem(
        header: const IconAvatar(
          icon: Icon(
            Icons.upload,
            color: Colors.white,
          ),
        ),
        body: Container(
          margin: left10,
          child: Text("上传 APK 文件", style: text16Bold),
        ),
        func: () {},
      );
}
