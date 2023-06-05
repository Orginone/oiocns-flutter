


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/unified.dart';

class StoreItem extends StatelessWidget {
  const StoreItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 11.h),
      child: Row(
        children: [
          Container(
            height: 80.w,
            width: 80.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFF17BC84),
              borderRadius: BorderRadius.circular(16.w),
            ),
            child: Icon(Icons.other_houses,color: Colors.white,size: 48.w,),
          ),
          SizedBox(width: 20.w,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("应用名称",style: XFonts.size24Black0,),
                Text("存储占用",style: XFonts.size18Black9,)
              ],
            ),
          ),
          GestureDetector(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 15.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.w),
                border: Border.all(color: Colors.grey.shade400, width: 0.5),
              ),
              child: Text(
                "打开",
                style: XFonts.size20Black0,
              ),
            ),
          ),
          CommonWidget.commonPopupMenuButton(items: [
            PopupMenuItem(child: Text("设为常用")),
          ])
        ],
      ),
    );
  }
}
