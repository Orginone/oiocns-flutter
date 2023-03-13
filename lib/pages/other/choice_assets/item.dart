import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/dart/core/target/species/ispecies.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/common_tree_management.dart';




class Item extends StatelessWidget {
  final AssetsCategoryGroup categoryGroup;

  const Item({Key? key, required this.categoryGroup}) : super(key: key);

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
                    text: categoryGroup.name,
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
                  AssetsCategoryGroup selected = categoryGroup.nextLevel[index];
                  Get.toNamed(Routers.choiceSpecificAssets,arguments:{"selected":selected});
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
                          categoryGroup.nextLevel[index].name,
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
            itemCount: categoryGroup.nextLevel.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
          )
        ],
      ),
    );
  }


}
