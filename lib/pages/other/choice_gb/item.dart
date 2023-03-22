import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/target/itarget.dart';
import 'package:orginone/dart/core/thing/ispecies.dart';
import 'package:orginone/widget/common_widget.dart';

import 'logic.dart';
import 'state.dart';

class Item extends StatelessWidget {
  final ISpeciesItem item;

  final VoidCallback? next;

  final ValueChanged? onChanged;

  final ISpeciesItem? selected;

  const Item(
      {Key? key,
        required this.item,
        this.next,
        this.onChanged,
        this.selected})
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
              child: CommonWidget.commonRadioTextWidget(
                item.name,
                item,
                groupValue: selected,
                onChanged: (v) {
                  item.isSelected = !item.isSelected;
                  if (onChanged != null) {
                    onChanged!(v);
                  }
                },
              ),
            ),
            item.children.isNotEmpty?GestureDetector(
              onTap: next,
              child: Icon(
                Icons.navigate_next,
                size: 32.w,
              ),
            ):const SizedBox(),
          ],
        ),
      ),
    );
  }
}
