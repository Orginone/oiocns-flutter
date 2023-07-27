import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/widget/image_widget.dart';
import 'package:orginone/widget/unified.dart';

class DigitalAssetsItem extends StatelessWidget {
  const DigitalAssetsItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: XColors.cardShadowColor,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 200.h,
                  width: double.infinity,
                  child: ImageWidget(
                    "https://t7.baidu.com/it/u=355704943,1318565630&fm=193&f=GIF",
                    radius: 14.w,
                    fit: BoxFit.fill,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: XColors.blueTextColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(14.w),
                        bottomRight: Radius.circular(14.w)),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  child: Text(
                    "已售馨",
                    style: TextStyle(color: Colors.white, fontSize: 18.sp),
                  ),
                )
              ],
            ),
            const Text("我是名称"),
            Wrap(
              spacing: 10.w,
              runSpacing: 5.h,
              children: [
                tag("我是标签"),
                tag("我是标签11111"),
              ],
            ),
            Text(
              "发行方：我是发行方",
              style:
                  TextStyle(color: XColors.blueTextColor, fontSize: 14.sp),
            ),
            Text(
              "发行平台：我是发行平台",
              style:
                  TextStyle(color: XColors.blueTextColor, fontSize: 14.sp),
            ),
            SizedBox(height: 10.h,),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: XColors.blueTextColor, width: 1),
                borderRadius: BorderRadius.circular(32.w),
              ),
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                            text: "233",
                            style: TextStyle(
                                color: XColors.blueTextColor,
                                fontSize: 34.sp,
                                fontWeight: FontWeight.w500)),
                        TextSpan(text: "份", style: TextStyle(fontSize: 14.sp)),
                      ],
                    ),
                  ),
                  Text("免费",style: TextStyle(color: Colors.red,fontSize: 22.sp),)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget tag(String tag) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 2.h),
      decoration: BoxDecoration(
        color: XColors.blueTextColor,
        borderRadius: BorderRadius.circular(14.w),
      ),
      child: Text(
        tag,
        style: TextStyle(color: XColors.white, fontSize: 16.sp),
      ),
    );
  }
}
