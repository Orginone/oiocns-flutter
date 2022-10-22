import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/page/home/center/center_controller.dart';

import '../../../component/unified_colors.dart';
import '../../../component/unified_text_style.dart';

enum Functions {
  addFriends("加好友"),
  createUnits("创单位"),
  inviteMembers("邀成员"),
  createApplication("建应用"),
  scanShop("逛商店");

  final String funcName;

  const Functions(this.funcName);
}

class CenterPage extends GetView<CenterController> {
  const CenterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: UnifiedColors.designLightBlue,
      child: Column(
        children: [
          _swiper,
          Container(margin: EdgeInsets.only(top: 12.h)),
          Container(
            margin: EdgeInsets.only(left: 20.w, right: 20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("快捷入口", style: text16Bold),
                Container(height: 8.h),
                Container(
                  height: 72.w,
                  child: ListView.builder(
                    itemCount: Functions.values.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      var value = Functions.values[index];
                      return Row(children: [
                        _fastEntry(value.funcName),
                        Container(margin: EdgeInsets.only(right: 8.w))
                      ]);
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  get _swiper => SizedBox(
        height: 130.h,
        child: Swiper(
          autoplay: true,
          itemCount: 4,
          itemBuilder: (BuildContext context, int index) {
            return CachedNetworkImage(
                height: 130.h,
                imageUrl:
                    "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fc-ssl.duitang.com%2Fuploads%2Fblog%2F202105%2F04%2F20210504062111_d8dc3.thumb.1000_0.jpg&refer=http%3A%2F%2Fc-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1668839600&t=153f1b08bff7c682539eabde8c2f862f");
          },
        ),
      );

  Widget _fastEntry(String keyWord) {
    return Container(
      alignment: Alignment.center,
      width: 72.w,
      height: 72.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10.w)),
      ),
      child: Wrap(
        direction: Axis.vertical,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Icon(
            Icons.add,
            color: UnifiedColors.designBlue,
            size: 30.w,
          ),
          Text(
            keyWord,
            style: TextStyle(
              color: UnifiedColors.designBlue,
              fontSize: 14.sp,
            ),
          )
        ],
      ),
    );
  }
}
