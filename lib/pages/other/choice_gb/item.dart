import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/thing/ispecies.dart';
import 'package:orginone/images.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/widget/common_widget.dart';

import 'state.dart';

class Item extends StatelessWidget {
  final ISpeciesItem item;

  final VoidCallback? next;

  final ValueChanged? onChanged;

  final ISpeciesItem? selected;

  final bool showChoice;

  final bool showFunctionButton;

  final FunctionMenu functionMenu;

  const Item(
      {Key? key,
      required this.item,
      this.next,
      this.onChanged,
      this.selected,
      this.showChoice = true,
      this.showFunctionButton = false, required this.functionMenu})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: next,
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Colors.grey.shade200, width: 0.5)),
          ),
          child: Row(
            children: [
              Expanded(
                child: title(),
              ),
              functionMenu == FunctionMenu.next?more():details(),
              showFunctionButton?_popupMenuButton():Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget title() {
    if (showChoice) {
      return CommonWidget.commonRadioTextWidget(
        item.name,
        item,
        groupValue: selected,
        onChanged: (v) {
          item.isSelected = !item.isSelected;
          if (onChanged != null) {
            onChanged!(v);
          }
        },
      );
    }
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      width: double.infinity,
      color: Colors.white,
      child: Text(
        item.name,
        style: TextStyle(fontSize: 18.sp, color: Colors.black),
      ),
    );
  }

  Widget more() {
    if (item.children.isNotEmpty) {
      return Icon(
        Icons.navigate_next,
        size: 32.w,
      );
    }
    return const SizedBox();
  }

  Widget details() {
    return GestureDetector(
      onTap: (){
        Get.toNamed(Routers.thing,arguments: {"id":item.id,"title":item.name});
      },
      child: Image.asset(
        Images.moreIcon,
        width: 26.w,
        height: 26.w,
      ),
    );
  }

  Widget _popupMenuButton(){
    return PopupMenuButton(
      icon:Icon(
        Icons.more_vert_outlined,
        size: 32.w,
      ),
      itemBuilder: (BuildContext context){
        return [
          const PopupMenuItem(value: "createThing",child: Text("创建实体"),),
        ];
      },
    );
  }
}
