import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/components/unified.dart';

class ScrollableMenu extends StatefulWidget {
  @override
  _ScrollableMenuState createState() => _ScrollableMenuState();
}

class _ScrollableMenuState extends State<ScrollableMenu> {
  // TODO 改为名称、icon、func
  List<String> menuItems = ["加好友", "创单位", "邀成员", "建应用", "逛商城", "创单位", "邀请员"];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: XColors.white, borderRadius: BorderRadius.circular(10)),
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: menuItems.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 13),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  // color:
                  //     index == selectedIndex ? Colors.blue : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    ElevatedButton.icon(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        print(menuItems[index]);
                        Get.defaultDialog();
                      },
                      // label: Text(menuItems[index]),
                      label: Text(''),
                    ),
                    Row(
                      children: [Text(menuItems[index])],
                    )
                  ],
                )),
          );
        },
      ),
    );
  }
}
