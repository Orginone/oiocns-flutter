import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/getwidget.dart';
import 'package:orginone/api_resp/target_resp.dart';
import 'package:orginone/config/custom_colors.dart';
import 'package:orginone/page/home/organization/organization_controller.dart';

import '../../../component/choose_item.dart';
import '../../../component/icon_avatar.dart';
import '../../../component/unified_edge_insets.dart';
import '../../../component/unified_text_style.dart';
import '../../../routers.dart';
import '../home_controller.dart';

class OrganizationPage extends GetView<OrganizationController> {
  const OrganizationPage({Key? key}) : super(key: key);

  Widget _unit() {
    HomeController homeController = Get.find<HomeController>();
    TargetResp targetResp = homeController.currentSpace;
    return ChooseItem(
        header: const IconAvatar(
          icon: Icon(
            Icons.account_tree,
            color: Colors.white,
          ),
        ),
        body: Container(
          margin: left10,
          child: Text(
            targetResp.name,
            style: text16Bold,
          ),
        ),
        func: () {
          Get.toNamed(Routers.units);
        },
        operate: GFButton(
          size: GFSize.SMALL,
          color: CustomColors.darkGreen,
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
              func: () {
                Get.toNamed(Routers.dept);
              })
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrganizationController>(
        init: controller,
        builder: (controller) {
          List<Widget> items = [];
          HomeController homeController = Get.find<HomeController>();

          // 好友管理
          items.add(ChooseItem(
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
              }));

          // 群组管理
          items.add(ChooseItem(
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
              }));

          if (controller.userInfo.id != homeController.currentSpace.id) {
            // 集团管理
            items.add(ChooseItem(
                header: const IconAvatar(
                  icon: Icon(
                    Icons.group_add_sharp,
                    color: Colors.white,
                  ),
                ),
                body: Container(
                  margin: EdgeInsets.only(left: left10),
                  child: Text("我的集团", style: text16Bold),
                ),
                func: () {
                  Get.toNamed(Routers.groups);
                }));
            // 单位管理
            items.add(_unit());
          }
          return ListView(children: items);
        });
  }
}

// class ChooseItem extends StatelessWidget {
//   final Widget header;
//   final String label;
//   final Function goto;
//   final Widget? operate;
//   final List<Widget>? body;
//
//   const ChooseItem(
//       {Key? key,
//       required this.header,
//       required this.label,
//       required this.goto,
//       this.operate,
//       this.body})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     List<Widget> content = [];
//     Widget basics = Container(
//         padding: const EdgeInsets.fromLTRB(10, 10, 20, 0),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             header,
//             Expanded(
//               child: Container(
//                   margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
//                   child: Text(
//                     label,
//                     style: text16Bold,
//                   )),
//             ),
//             operate == null
//                 ? Container(
//                     margin: const EdgeInsets.all(5),
//                     child: const Icon(Icons.keyboard_arrow_right))
//                 : operate!
//           ],
//         ));
//     content.add(basics);
//     if (body != null) {
//       content.addAll(body!);
//     }
//     return GestureDetector(
//         behavior: HitTestBehavior.opaque,
//         onTap: () {
//           goto();
//         },
//         child: Column(children: content));
//   }
// }
