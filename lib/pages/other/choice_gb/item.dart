import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/dart/core/thing/ispecies.dart';
import 'package:orginone/images.dart';
import 'package:orginone/widget/common_widget.dart';

class Item extends StatelessWidget {
  final ISpeciesItem item;

  final VoidCallback? next;

  final ValueChanged? onChanged;

  final ISpeciesItem? selected;

  final bool showChoice;

  final bool showFunctionButton;

  const Item(
      {Key? key,
      required this.item,
      this.next,
      this.onChanged,
      this.selected,
      this.showChoice = true,
      this.showFunctionButton = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
            more(),
            _popupMenuButton(context),
          ],
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
      return GestureDetector(
        onTap: next,
        child: Image.asset(
          Images.moreIcon,
          width: 26.w,
          height: 26.w,
        ),
      );
    }
    return const SizedBox();
  }

  PopupMenuButton _popupMenuButton(BuildContext context){
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
