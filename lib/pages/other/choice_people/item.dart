import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/widget/common_widget.dart';

import 'logic.dart';
import 'state.dart';

class GroupItem extends StatelessWidget {
  final ITarget department;

  final VoidCallback? onTap;

  const GroupItem({Key? key, required this.department, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return group();
  }

  Widget group() {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Colors.grey.shade200, width: 0.5)),
          ),
          padding: EdgeInsets.symmetric(vertical: 20.h),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  department.metadata.name ?? "",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize:  20.sp),
                ),
              ),
              Icon(
                Icons.speaker_group,
                size: 32.w,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PeopleItem extends StatelessWidget {
  final XTarget people;

  final ValueChanged? onChanged;

  const PeopleItem({Key? key, required this.people, this.onChanged})
      : super(key: key);

  ChoicePeopleController get choicePeopleController =>
      Get.find<ChoicePeopleController>();

  @override
  Widget build(BuildContext context) {
    return radio();
  }

  Widget radio() {
    return Obx(() {
      return CommonWidget.commonRadioTextWidget(people.name ?? "", people,
          groupValue: choicePeopleController.state.selectedUser.value,
          onChanged: (v) {
        people.isSelected = !people.isSelected;
        if (onChanged != null) {
          onChanged!(v);
        }
      });
    });
  }
}
