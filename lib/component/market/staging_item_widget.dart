import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/api_resp/staging_entity.dart';
import 'package:orginone/component/a_font.dart';
import 'package:orginone/component/choose_item.dart';
import 'package:orginone/component/icon_avatar.dart';

class StagingItemWidget extends StatelessWidget {
  final StagingEntity staging;
  final String belongName;

  const StagingItemWidget({
    Key? key,
    required this.staging,
    required this.belongName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChooseItem(
      bgColor: Colors.white,
      padding: EdgeInsets.all(20.w),
      margin: EdgeInsets.only(top: 10.h, bottom: 10.h, left: 20.w, right: 20.w),
      header: Column(
        children: [
          IconAvatar(
            width: 64.w,
            radius: 20.w,
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.group, color: Colors.white),
          ),
          Padding(padding: EdgeInsets.only(top: 10.h)),
          Text("v 0.0.1", style: AFont.instance.size12Black9),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(staging.merchandise.caption ?? "",
              style: AFont.instance.size14Black3W500),
          Padding(padding: EdgeInsets.only(top: 10.h)),
          Text("归属: $belongName  版本:v 0.0.1",
              style: AFont.instance.size14Black6),
          Padding(padding: EdgeInsets.only(top: 10.h)),
          Text(
            "价格: ￥${staging.merchandise.price ?? "0.00"}",
            style: AFont.instance.size14Black6,
          ),
          Padding(padding: EdgeInsets.only(top: 10.h)),
          Text(
            "售卖权属: ${staging.merchandise.sellAuth ?? ""}",
            style: AFont.instance.size14Black6,
          ),
        ],
      ),
      func: () {},
    );
  }
}
