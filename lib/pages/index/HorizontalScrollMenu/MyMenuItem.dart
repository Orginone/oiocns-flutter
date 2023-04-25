import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/routers.dart';

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
  LinkedHashMap<int, MyMenuItem> menuItems = LinkedHashMap.from({
    1: MyMenuItem(
        id: 1,
        icon: Icons.add,
        cardName: '加好友',
        func: () {
          Get.toNamed(Routers.addFriend);
          print('Go to home page');
        }),
    2: MyMenuItem(
        id: 2,
        icon: Icons.search,
        cardName: '创单位',
        func: () => print('Go to search page')),
    3: MyMenuItem(
        id: 3,
        icon: Icons.settings,
        cardName: '邀成员',
        func: () => print('Go to settings page')),
    4: MyMenuItem(
        id: 4,
        icon: Icons.person,
        cardName: '建应用',
        func: () => print('Go to profile page')),
    5: MyMenuItem(
        id: 5,
        icon: Icons.search,
        cardName: '逛商店',
        func: () => print('Go to search page')),
    6: MyMenuItem(
        id: 6,
        icon: Icons.settings,
        cardName: '通讯录',
        func: () => print('Go to settings page')),
    7: MyMenuItem(
        id: 7,
        icon: Icons.person,
        cardName: '创单位',
        func: () => print('Go to profile page')),
  });

  late int _selectedItemId;

  @override
  void initState() {
    super.initState();
    _selectedItemId = menuItems.keys.first;
  }

  @override
  Widget build(BuildContext context) {
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
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color:
                    itemId == _selectedItemId ? Colors.blue : Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(menuItem?.icon,
                      color: itemId == _selectedItemId
                          ? Colors.white
                          : Colors.black),
                  SizedBox(height: 6.h),
                  Text(menuItem!.cardName,
                      style: TextStyle(
                          color: itemId == _selectedItemId
                              ? Colors.white
                              : Colors.black)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
