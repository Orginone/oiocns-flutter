import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/dart/core/target/itarget.dart';
import 'package:orginone/widget/common_widget.dart';

import '../choice_people/state.dart';

class Item extends StatelessWidget {
  final ITarget choicePeople;

  final VoidCallback? next;

  final ValueChanged? onChanged;

  final ITarget? selected;

  const Item(
      {Key? key,
      required this.choicePeople,
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
                choicePeople.name ?? "",
                choicePeople,
                groupValue: selected,
                onChanged: (v) {
                  choicePeople.isSelected = !choicePeople.isSelected;
                  if (onChanged != null) {
                    onChanged!(v);
                  }
                },
              ),
            ),
            GestureDetector(
              onTap: next,
              child: Icon(
                Icons.speaker_group,
                size: 32.w,
              ),
            )
          ],
        ),
      ),
    );
  }
}
