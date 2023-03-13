import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/widget/common_widget.dart';

import 'logic.dart';
import 'state.dart';

class Item extends StatelessWidget {
  final StorageLocation location;

  final VoidCallback? onTap;

  final ValueChanged? onChanged;

  const Item({Key? key, required this.location, this.onTap, this.onChanged})
      : super(key: key);

  StorageLocationController get locationController =>
      Get.find<StorageLocationController>();

  @override
  Widget build(BuildContext context) {
    return (location.last ?? false) ? radio() : group();
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
                  location.placeName ?? "",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: location.hasSelected() ? FontWeight.w500 : null,
                      fontSize: location.hasSelected() ? 24.sp : 20.sp),
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

  Widget radio() {
    return Obx(() {
      return CommonWidget.commonRadioTextWidget(
          location.placeName ?? "", location,
          groupValue: locationController.state.selectedLocation.value,
          onChanged: (v) {
            location.isSelected = true;
            if (onChanged != null) {
              onChanged!(v);
            }
          });
    });
  }
}
