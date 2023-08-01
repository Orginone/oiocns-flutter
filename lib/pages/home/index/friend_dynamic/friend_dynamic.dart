



import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/images.dart';
import 'package:orginone/pages/home/index/widget/widget.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/image_widget.dart';
import 'package:orginone/widget/unified.dart';

class FriendDynamic extends StatefulWidget {
  const FriendDynamic({Key? key}) : super(key: key);

  @override
  State<FriendDynamic> createState() => _FriendDynamicState();
}

class _FriendDynamicState extends State<FriendDynamic> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 15.h),
      children: [
        concerned(),
        SizedBox(height: 10.h),
        newDynamic(),
      ],
    );
  }


  Widget concerned(){
    return Card(
      shadowColor: XColors.cardShadowColor,
      elevation: 1.25,
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      child: Padding(
        padding:EdgeInsets.symmetric(horizontal: 10.w,vertical: 5.h),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("特别关心",style: XFonts.size22Black0W700,),
                TextArrow(title: '',)
              ],
            ),
            SizedBox(height: 10.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(5, (index) => ColumnItem())
            )
          ],
        ),
      ),
    );
  }

  Widget newDynamic(){
    return Column(
      children: [
        CommonWidget.commonHeadInfoWidget("最新动态", action: TextArrow(title: "查看全部动态",)),
        SizedBox(height: 10.h,),
        ...List.generate(5, (index) =>  CardItem()).toList(),
      ],
    );
  }

}
