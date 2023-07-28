
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/images.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/image_widget.dart';
import 'package:orginone/widget/unified.dart';

import 'welfare_item.dart';

class Welfare extends StatefulWidget {
  const Welfare({Key? key}) : super(key: key);

  @override
  State<Welfare> createState() => _WelfareState();
}

class _WelfareState extends State<Welfare> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 15.h),
      children: [
        head(),
        body("教育助学"),
        body("乡村振兴"),
        body("灾害救援"),
        body("自然保护"),
        body("关怀倡导"),
      ],
    );
  }

  Widget head(){
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: XColors.statisticsBoxColor,width: 1))
      ),
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          imageContent(Images.imageEverytime,"每次捐"),
          imageContent(Images.imageMonthly,"每月捐"),
          imageContent(Images.imageProject,"发现项目"),
          imageContent(Images.imageProgress,"最新进展"),
        ],
      ),
    );
  }

  Widget imageContent(String image,String content,[VoidCallback? onTap]){
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          ImageWidget(image,size: 40.w,),
          SizedBox(height: 10.h,),
          Text(content),
        ],
      ),
    );
  }

  Widget body(String info){
    return  Container(
      margin: EdgeInsets.only(top: 10.h),
      child: Column(
        children: [
          CommonWidget.commonHeadInfoWidget(info, action: ImageWidget(Images.iconBlueArrow)),
          SizedBox(height: 10.h,),
          ...List.generate(3, (index) =>  WelfareItem()).toList(),
        ],
      ),
    );
  }


}
