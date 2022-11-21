import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/api_resp/merchandise_entity.dart';
import 'package:orginone/component/a_font.dart';
import 'package:orginone/component/choose_item.dart';
import 'package:orginone/component/icon_avatar.dart';
import 'package:orginone/component/text_tag.dart';
import 'package:orginone/component/unified_colors.dart';

class MerchandiseItemWidget extends StatelessWidget {
  final MerchandiseEntity merchandise;
  final String belongName;

  const MerchandiseItemWidget({
    Key? key,
    required this.merchandise,
    required this.belongName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _item;
  }

  get _item {
    return ChooseItem(
      bgColor: Colors.white,
      padding: EdgeInsets.all(20.w),
      margin: EdgeInsets.only(bottom: 20.h, left: 20.w, right: 20.w),
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
          Text(merchandise.caption, style: AFont.instance.size14Black3W500),
          Padding(padding: EdgeInsets.only(top: 10.h)),
          Text("归属:$belongName  编码:${merchandise.product.code}",
              style: AFont.instance.size14Black6),
          Padding(padding: EdgeInsets.only(top: 10.h)),
          Text(
            merchandise.product.remark ?? "",
            overflow: TextOverflow.ellipsis,
            style: AFont.instance.size12Black9,
            maxLines: 3,
          ),
        ],
      ),
      operate: Wrap(
        children: [
          Padding(padding: EdgeInsets.only(left: 10.w)),
          TextTag(
            "加入购物车",
            borderColor: UnifiedColors.themeColor,
            bgColor: Colors.white,
            padding: EdgeInsets.all(5.w),
            textStyle: AFont.instance.size12themeColor,
          ),
          Padding(padding: EdgeInsets.only(left: 10.w)),
          TextTag(
            "获取",
            borderColor: UnifiedColors.themeColor,
            bgColor: Colors.white,
            padding: EdgeInsets.all(5.w),
            textStyle: AFont.instance.size12themeColor,
          ),
        ],
      ),
      func: () {},
    );
  }
}
