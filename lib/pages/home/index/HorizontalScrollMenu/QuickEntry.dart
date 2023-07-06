import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/controller/setting/user_controller.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/main.dart';
import 'package:orginone/pages/setting/dialog.dart';
import 'package:orginone/pages/setting/user_info/state.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/toast_utils.dart';
import 'package:orginone/widget/unified.dart';


class MyMenuItem {
  final int id;
  final IconData icon;
  final String cardName;
  final Function func;

  MyMenuItem(
      {required this.id,
      required this.icon,
      required this.cardName,
      required this.func});
}

class MyHorizontalMenu extends StatefulWidget {
  const MyHorizontalMenu({super.key});

  @override
  _MyHorizontalMenuState createState() => _MyHorizontalMenuState();
}

class _MyHorizontalMenuState extends State<MyHorizontalMenu> {
  late int _selectedItemId;
/*
2023年6月1日
测试通过：定标准、加好友、建群组、建单位
测试未通过：、加群组、、加单位
*/

  LinkedHashMap<int, MyMenuItem> menuItems = LinkedHashMap.from({
    1: MyMenuItem(
        id: 1,
        icon: Icons.add,
        cardName: '定标准',
        func: () {
          Get.toNamed(Routers.settingCenter);
        }),
    2: MyMenuItem(
        id: 2,
        icon: Icons.search,
        cardName: '加好友',
        func: () {
          final UserInfoState state = UserInfoState();
          showSearchDialog(Get.context!, TargetType.person,
              title: "添加好友",
              hint: "请输入用户的账号", onSelected: (List<XTarget> list) async {

            if (list.isNotEmpty) {
              bool success =
                  await settingCtrl.user.pullMembers(list);
              if (success) {
                state.unitMember.addAll(list);
                state.unitMember.refresh();
                ToastUtils.showMsg(msg: "好友申请发送成功");
              } else {
                ToastUtils.showMsg(msg: "好友申请发送失败");
              }
            }
          });
        }),
    3: MyMenuItem(
        id: 3,
        icon: Icons.settings,
        cardName: '建群组',
        func: () {
          settingCtrl.showAddFeatures(
              ItemModel(Shortcut.addCohort, "建群聊", "建群组", TargetType.cohort));
        }),
    4: MyMenuItem(
        id: 4,
        icon: Icons.person,
        cardName: '加群组',
        func: () {
          settingCtrl.showAddFeatures(ItemModel(
              Shortcut.addGroup, "添加群组", "请输入群组的编码", TargetType.cohort));
        }),
    5: MyMenuItem(
        id: 5,
        icon: Icons.search,
        cardName: '建单位',
        func: () {
          showCreateOrganizationDialog(
            Get.context!,
            [TargetType.company],
            callBack: (String name, String code, String nickName,
                String identify, String remark, TargetType type) async {
              var target = TargetModel(
                name: nickName,
                code: code,
                typeName: type.label,
                teamName: name,
                teamCode: code,
                remark: remark,
              );
              var company = await settingCtrl.user.createCompany(target);
              if(company!=null){
                ToastUtils.showMsg(msg: "新建成功");
              }
            },
          );
        }),
    6: MyMenuItem(
        id: 6,
        icon: Icons.settings,
        cardName: '加单位',
        func: () {
          settingCtrl.showAddFeatures(ItemModel(
              Shortcut.addCompany, "添加单位", "请输入单位的社会统一代码", TargetType.company));
        }),
  });

  @override
  void initState() {
    super.initState();
    _selectedItemId = menuItems.length + 1;
  }
  @override
  Widget build(BuildContext context) {
    XColors.white;
    return Container(
      height: 74,
      child: ListView.builder(
        itemCount: menuItems.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          int itemId = menuItems.keys.elementAt(index);
          MyMenuItem? menuItem = menuItems[itemId];
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedItemId = itemId;
              });
              menuItem?.func();
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 12.h),
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color:
                    itemId == _selectedItemId ? Colors.blue : XColors.entryBgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(menuItem?.icon,
                      color: itemId == _selectedItemId
                          ? Colors.white
                          : XColors.entryColor),
                  SizedBox(height: 6.h),
                  Text(menuItem!.cardName,
                      style: TextStyle(
                          color: itemId == _selectedItemId
                              ? Colors.white
                              : XColors.entryColor)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
