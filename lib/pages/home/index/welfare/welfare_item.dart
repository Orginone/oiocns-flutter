import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/util/date_utils.dart';
import 'package:orginone/widget/image_widget.dart';
import 'package:orginone/widget/unified.dart';

class WelfareItem extends StatelessWidget {
  const WelfareItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: XColors.cardShadowColor,
      margin: EdgeInsets.symmetric(horizontal: 10.w,vertical: 5.h),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 200.w,
              height: 160.h,
              child: ImageWidget(
                "https://lmg.jj20.com/up/allimg/tp05/1Z9291S23R619-0-lp.jpg",
                radius: 12.w,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "标题",
                      style: XFonts.size22Black0,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Wrap(
                      spacing: 10.w,
                      runSpacing: 5.h,
                      children: [
                        tag("我是标签"),
                        tag("我是标签11111"),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "内容摘要内容摘要内容摘要内容摘要内容摘要内容摘要内容摘要内容摘要内容摘要内容摘要内容摘要",
                      style: TextStyle(
                          color: XColors.blueHintTextColor, fontSize: 16.sp),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text.rich(
                       TextSpan(
                         children: [
                           TextSpan(text:  "200.9万",
                             style: XFonts.size16Black9,),
                           TextSpan(text: "  爱心网友捐助",
                             style: XFonts.size16Black9,)
                         ]
                       )
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }

  Widget tag(String tag) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
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
