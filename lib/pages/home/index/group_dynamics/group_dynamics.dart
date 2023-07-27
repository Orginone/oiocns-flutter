import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getwidget/getwidget.dart';
import 'package:orginone/images.dart';
import 'package:orginone/main.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/image_widget.dart';
import 'package:orginone/widget/unified.dart';

import 'dynamic_item.dart';

class GroupDynamics extends StatefulWidget {
  const GroupDynamics({Key? key}) : super(key: key);

  @override
  State<GroupDynamics> createState() => _GroupDynamicsState();
}

class _GroupDynamicsState extends State<GroupDynamics> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 15.h),
      children: [
        mostViewed(),
        SizedBox(height: 10.h,),
        news(),
        SizedBox(height: 10.h),
        newDynamic(),
      ],
    );
  }

  Widget news(){
    return GFCarousel(
      hasPagination: true,
      activeIndicator: GFColors.WHITE,
      height: 200.h,
      autoPlay: true,
      items: ['https://lmg.jj20.com/up/allimg/tp05/1Z9291S23R619-0-lp.jpg','https://lmg.jj20.com/up/allimg/1112/031319114916/1Z313114916-3-1200.jpg'].map(
            (img) {
          return Container(
            margin: EdgeInsets.only(left: 8.w),
            width: double.infinity,
            child: ImageWidget(
              img,
              radius: 5.w,
              fit: BoxFit.fill,

            ),
          );
        },
      ).toList(),
    );
  }

  Widget mostViewed(){
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
                Text("最常浏览",style: XFonts.size22Black0W700,),
                arrow("查看我的关注")
              ],
            ),
            SizedBox(height: 10.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    ImageWidget("https://t7.baidu.com/it/u=4162611394,4275913936&fm=193&f=GIF",circular: true,size: 60.w,),
                    Text("名字"),
                  ],
                ),
                Column(
                  children: [
                    ImageWidget("https://t7.baidu.com/it/u=4162611394,4275913936&fm=193&f=GIF",circular: true,size: 60.w,),
                    Text("名字"),
                  ],
                ),
                Column(
                  children: [
                    ImageWidget("https://t7.baidu.com/it/u=4162611394,4275913936&fm=193&f=GIF",circular: true,size: 60.w,),
                    Text("名字"),
                  ],
                ),
                Column(
                  children: [
                    ImageWidget("https://t7.baidu.com/it/u=4162611394,4275913936&fm=193&f=GIF",circular: true,size: 60.w,),
                    Text("名字"),
                  ],
                ),
                Column(
                  children: [
                    ImageWidget("https://t7.baidu.com/it/u=4162611394,4275913936&fm=193&f=GIF",circular: true,size: 60.w,),
                    Text("名字"),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget newDynamic(){
    return Column(
      children: [
        CommonWidget.commonHeadInfoWidget("最新动态", action: arrow('查看全部动态')),
        SizedBox(height: 10.h,),
        ...List.generate(5, (index) =>  DynamicItem()).toList(),
      ],
    );
  }


  Widget arrow(String title, [VoidCallback? onTap]) {
    return GestureDetector(
      onTap: onTap,
      child: Text.rich(TextSpan(children: [
        TextSpan(text: title, style: TextStyle(fontSize: 18.sp)),
        WidgetSpan(
            child: Container(
                margin: EdgeInsets.only(left: 10.w),
                child: const ImageWidget(Images.iconBlueArrow)),
            alignment: PlaceholderAlignment.middle)
      ])),
    );
  }


  
}
