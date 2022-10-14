import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:orginone/api_resp/target_resp.dart';
import 'package:orginone/component/unified_colors.dart';
import 'package:orginone/page/home/organization/organization_controller.dart';

import '../../../component/choose_item.dart';
import '../../../component/icon_avatar.dart';
import '../../../component/unified_edge_insets.dart';
import '../../../component/unified_text_style.dart';
import '../../../routers.dart';
import '../home_controller.dart';

class OrganizationPage extends GetView<OrganizationController> {
  const OrganizationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrganizationController>(
      init: controller,
      builder: (controller) {
        List<Widget> items = [];
        HomeController homeController = Get.find<HomeController>();
        // 好友管理，群组管理
        items.add(_friends);
        items.add(_cohorts);
        // 集团管理，单位管理
        if (controller.userInfo.id != homeController.currentSpace.id) {
          items.add(_groups);
          items.add(_unit);
        }
        return ListView(children: items);
      },
    );
  }

  get _friends => ChooseItem(
        header: const IconAvatar(
          icon: Icon(
            Icons.group,
            color: Colors.white,
          ),
        ),
        body: Container(
          margin: left10,
          child: Text("我的好友", style: text16Bold),
        ),
        func: () {
          Get.toNamed(Routers.friends);
        },
      );

  get _cohorts => ChooseItem(
        header: const IconAvatar(
          icon: Icon(
            Icons.group,
            color: Colors.white,
          ),
        ),
        body: Container(
          margin: left10,
          child: Text("我的群组", style: text16Bold),
        ),
        func: () {
          Get.toNamed(Routers.cohorts);
        },
      );

  get _groups => ChooseItem(
        header: const IconAvatar(
          icon: Icon(
            Icons.group_add_sharp,
            color: Colors.white,
          ),
        ),
        body: Container(
          margin: left10,
          child: Text("我的集团", style: text16Bold),
        ),
        func: () {
          Get.toNamed(Routers.groups);
        },
      );

  get _unit {
    HomeController homeController = Get.find<HomeController>();
    TargetResp targetResp = homeController.currentSpace;
    return ChooseItem(
      header: const IconAvatar(
        icon: Icon(
          Icons.account_tree,
          color: Colors.white,
        ),
      ),
      body: Expanded(
        child: Container(
          margin: left10,
          child: Text(
            targetResp.name,
            style: text16Bold,
          ),
        ),
      ),
      func: () {
        Get.toNamed(Routers.units);
      },
      operate: GFButton(
        size: GFSize.SMALL,
        color: UnifiedColors.darkGreen,
        textColor: Colors.white,
        onPressed: () async {},
        text: "邀请",
      ),
      content: [
        ChooseItem(
          header: IconAvatar(
            icon: const Icon(
              Icons.subdirectory_arrow_right,
              color: Colors.black,
            ),
            bgColor: Colors.white.withOpacity(0),
          ),
          body: Container(
            margin: left10,
            child: Text("组织架构", style: text16Bold),
          ),
          padding: const EdgeInsets.only(left: 10, top: 10),
          func: () {
            Get.toNamed(Routers.dept);
          },
        )
      ],
    );
  }
}
