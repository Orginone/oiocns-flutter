import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/config/custom_colors.dart';
import 'package:orginone/page/home/organization/organization_controller.dart';

import '../../../routers.dart';

class OrganizationPage extends GetView<OrganizationController> {
  const OrganizationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ChooseItem(Icons.person, "我的好友", () {
          Get.toNamed(Routers.friends);
        }),
        ChooseItem(Icons.group, "我的群组", () {}),
        ChooseItem(Icons.account_box, "我的单位", () {
          Get.toNamed(Routers.units);
        }),
        ChooseItem(Icons.group_add_sharp, "我的集团", () {})
      ],
    );
  }
}

class ChooseItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Function goto;

  const ChooseItem(this.icon, this.label, this.goto, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          goto();
        },
        child: Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 20, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    padding: const EdgeInsets.all(15),
                    decoration: const BoxDecoration(
                        color: CustomColors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Icon(
                      icon,
                      color: Colors.white,
                    )),
                Expanded(
                    flex: 10,
                    child: Container(
                        margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Text(
                          label,
                          style: const TextStyle(fontSize: 15),
                        ))),
                const Expanded(flex: 1, child: Icon(Icons.keyboard_arrow_right))
              ],
            )));
  }
}
