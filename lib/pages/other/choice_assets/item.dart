import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/pages/other/choice_assets/state.dart';
import 'package:orginone/routers.dart';

import 'choice_specific_assets/view.dart';

class Item extends StatelessWidget {
  final ChildList childList;

  const Item({Key? key, required this.childList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      margin: EdgeInsets.only(top: 15.h),
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              children: [
                WidgetSpan(
                    child: Container(
                      width: 5.w,
                      height: 25.h,
                      margin: EdgeInsets.only(right: 15.w),
                      color: XColors.themeColor,
                    ),
                    alignment: PlaceholderAlignment.middle),
                TextSpan(
                    text: "${childList.categoryName}",
                    style: TextStyle(fontSize: 20.sp, color: Colors.black))
              ],
            ),
          ),
          GridView.builder(
            padding: EdgeInsets.zero,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,mainAxisExtent: 60),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: (){
                  Get.toNamed(Routers.choiceSpecificAssets,arguments:{"selected":childList.childList![index]});
                },
                child: SizedBox(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.network(
                          "https://gysz-nk.oss-cn-hangzhou.aliyuncs.com/assetControl/app/cate-common.png",width: 40.w,height: 40.w,),
                      SizedBox(width: 10.w,),
                      Expanded(
                        child: Text(
                          "${childList.childList![index].categoryName}",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 18.sp,overflow: TextOverflow.ellipsis),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            itemCount: childList.childList!.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
          )
        ],
      ),
    );
  }


}
