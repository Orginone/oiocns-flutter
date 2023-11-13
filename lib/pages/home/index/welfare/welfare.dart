import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/common/values/index.dart';

import 'package:orginone/pages/home/index/widget/widget.dart';
import 'package:orginone/components/widgets/common_widget.dart';
import 'package:orginone/components/widgets/image_widget.dart';
import 'package:orginone/config/unified.dart';

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

  Widget head() {
    return Container(
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(color: XColors.statisticsBoxColor, width: 1))),
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          imageContent(AssetsImages.imageEverytime, "每次捐"),
          imageContent(AssetsImages.imageMonthly, "每月捐"),
          imageContent(AssetsImages.imageProject, "发现项目"),
          imageContent(AssetsImages.imageProgress, "最新进展"),
        ],
      ),
    );
  }

  Widget imageContent(String image, String content, [VoidCallback? onTap]) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          ImageWidget(
            image,
            size: 40.w,
          ),
          SizedBox(
            height: 10.h,
          ),
          Text(content),
        ],
      ),
    );
  }

  Widget body(String info) {
    return Container(
      margin: EdgeInsets.only(top: 10.h),
      child: Column(
        children: [
          CommonWidget.commonHeadInfoWidget(info,
              action: const ImageWidget(AssetsImages.iconBlueArrow)),
          SizedBox(
            height: 10.h,
          ),
          ...List.generate(3, (index) => const CardItem()).toList(),
        ],
      ),
    );
  }
}
