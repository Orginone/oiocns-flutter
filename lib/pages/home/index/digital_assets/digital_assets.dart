import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/images.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/dynamic_height_grid_view.dart';
import 'package:orginone/widget/image_widget.dart';
import 'package:orginone/widget/unified.dart';

import '../widget/widget.dart';
import 'digital_assets_item.dart';

class DigitalAssets extends StatefulWidget {
  const DigitalAssets({Key? key}) : super(key: key);

  @override
  State<DigitalAssets> createState() => _DigitalAssetsState();
}

class _DigitalAssetsState extends State<DigitalAssets> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 15.h),
      children: [
        statistics(),
        SizedBox(height: 20.h,),
        newAssets(),
        SizedBox(height: 20.h,),
        assetIssuer(),
        SizedBox(height: 20.h,),
        related(),
        SizedBox(height: 20.h,),
        cooperativeUnit()
      ],
    );
  }

  Widget statistics() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      padding: EdgeInsets.symmetric(vertical: 15.h),
      decoration: BoxDecoration(
        color: XColors.statisticsBoxColor,
        borderRadius: BorderRadius.circular(14.w),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          statisticsItem(133, "数字资产总数"),
          statisticsItem(29, "发行方总数"),
          statisticsItem(7, "本月上新数"),
          statisticsItem(2, "当日上新"),
        ],
      ),
    );
  }

  Widget statisticsItem(int count, String title) {
    return Column(
      children: [
        SizedBox(
          height: 10.h,
        ),
        Text(
          count.toString(),
          style: TextStyle(
              color: XColors.blueTextColor,
              fontSize: 28.sp,
              fontWeight: FontWeight.w600),
        ),
        SizedBox(
          height: 5.h,
        ),
        Text(
          "个",
          style: TextStyle(color: XColors.blueTextColor, fontSize: 18.sp),
        ),
        SizedBox(
          height: 5.h,
        ),
        Text(title)
      ],
    );
  }

  Widget newAssets() {
    return Column(
      children: [
        CommonWidget.commonHeadInfoWidget("数字资产上新", action: TextArrow(title: "查看更多数字资产",)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: DynamicHeightGridView(
            itemCount: 4,
            crossAxisSpacing: 10.w,
            mainAxisSpacing: 10.h,
            builder: (context, index) {
              return DigitalAssetsItem();
            },
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
          ),
        )
      ],
    );
  }

  Widget assetIssuer() {
    return Column(
      children: [
        CommonWidget.commonHeadInfoWidget("数字资产发行方"),
        Container(
          height: 240.h,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: GridView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 12,
            itemBuilder: (context, index) {
              return Card( shadowColor: XColors.cardShadowColor,);
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10.h,
                crossAxisSpacing: 10.w,
                childAspectRatio: 0.6,
                mainAxisExtent: 200.w),
          ),
        )
      ],
    );
  }

  Widget related() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonWidget.commonHeadInfoWidget("相关制度", action: TextArrow(title: "查看更多相关制度",)),
        relatedItem(
          "《浙江XXXXXXXXXXXXXXXXXXXXXXXX管理规范》简介",
        ),
        relatedItem(
          "《浙江XXXXXXXXXXXXXXXXXXXXXXX管理规范》简介",
        ),
        relatedItem(
          "《浙江XXXXXXXXXXXXXXXXXXXXX管理规范》简介",
        )
      ],
    );
  }

  Widget cooperativeUnit(){
    return Column(
      children: [
        CommonWidget.commonHeadInfoWidget("合作单位"),
        Container(
          height: 120.h,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: GridView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 12,
            itemBuilder: (context, index) {
              return Card( shadowColor: XColors.cardShadowColor,);
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                mainAxisSpacing: 10.h,
                crossAxisSpacing: 10.w,
                childAspectRatio: 9/16,
            ),
          ),
        )
      ],
    );
  }


  Widget relatedItem(String title) {
    return GestureDetector(
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
          child: Text(
            title,
            style: XFonts.size20Black0,
          )),
    );
  }
}
