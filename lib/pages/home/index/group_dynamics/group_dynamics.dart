import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getwidget/getwidget.dart';

import 'package:orginone/main.dart';
import 'package:orginone/pages/home/index/widget/widget.dart';
import 'package:orginone/components/widgets/common_widget.dart';
import 'package:orginone/components/widgets/image_widget.dart';
import 'package:orginone/config/unified.dart';

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
        SizedBox(
          height: 10.h,
        ),
        const NewsPage(),
        SizedBox(height: 10.h),
        newDynamic(),
      ],
    );
  }

  Widget mostViewed() {
    return Card(
      shadowColor: XColors.cardShadowColor,
      elevation: 1.25,
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "最常浏览",
                  style: XFonts.size22Black0W700,
                ),
                const TextArrow(
                  title: "查看我的关注",
                )
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(5, (index) => const ColumnItem()))
          ],
        ),
      ),
    );
  }

  Widget newDynamic() {
    return Column(
      children: [
        CommonWidget.commonHeadInfoWidget("最新动态",
            action: const TextArrow(
              title: '查看全部动态',
            )),
        SizedBox(
          height: 10.h,
        ),
        ...List.generate(5, (index) => const CardItem()).toList(),
      ],
    );
  }
}
