import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/model/my_assets_list.dart';
import 'package:orginone/pages/other/assets_config.dart';
import 'package:orginone/pages/other/center_function/assets_check/check/state.dart';
import 'package:orginone/routers.dart';

class Item extends StatelessWidget {
  final CheckType checkType;
  final VoidCallback? onRecheck;
  final ValueChanged<CheckType>? onInventory;
  final MyAssetsList assets;
  const Item({Key? key, required this.checkType, this.onRecheck, this.onInventory, required this.assets}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routers.generalDetails,arguments: {"AssetsType":AssetsType.check});
      },
      child: Container(
        margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 20.h),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8.w)),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                taskInfo(),
                SizedBox(
                  height: 10.h,
                ),
                otherInfo(),
              ],
            ),
            Positioned(
              bottom: 30.h,
              right: 10.w,
              child: statusInfo(),
            )
          ],
        ),
      ),
    );
  }

  Widget statusInfo() {
    if(checkType == CheckType.notStarted){
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: (){
              if(onInventory!=null){
                onInventory!(CheckType.loss);
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5.h,horizontal: 8.w),
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(4.w)
              ),
              child: Column(
                children: [
                  Icon(Icons.add_home,size: 20.w,),
                  Text("盘亏",style: TextStyle(fontSize: 16.sp),)
                ],
              ),
            ),
          ),
          SizedBox(width: 10.w,),
          GestureDetector(
            onTap: (){
              if(onInventory!=null){
                onInventory!(CheckType.saved);
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5.h,horizontal: 8.w),
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(4.w)
              ),
              child: Column(
                children: [
                  Icon(Icons.add_home,size: 20.w,),
                  Text("盘存",style: TextStyle(fontSize: 16.sp))
                ],
              ),
            ),
          )
        ],
      );
    }
    return GestureDetector(
      onTap: onRecheck,
      child: Container(
        decoration: BoxDecoration(
          color: XColors.themeColor,
          borderRadius: BorderRadius.circular(8.w),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 20.w),
          alignment: Alignment.center,
          child: Text(
            "重新盘点",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
            ),
          ),
        ),
      ),
    );
  }

  Widget taskInfo() {
    String title = assets.assetName??"";
    String content = assets.assetCode??"";
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(8.w))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                color: XColors.themeColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 5.h,
          ),
          Text(
            content,
            style: TextStyle(
                color: Colors.black,
                fontSize: 24.sp,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget otherInfo() {
    Widget child = Row(
      children: [
        Image.network(
          "https://gysz-nk.oss-cn-hangzhou.aliyuncs.com/assetControl/app/rmb-icon.png",
          width: 20.w,
          height: 20.h,
        ),
        SizedBox(
          width: 10.w,
        ),
        Text(
          "${assets.netVal??0}",
          style: TextStyle(
              color: Colors.black,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500),
        ),
      ],
    );
    return Container(
      padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 10.h),
      child: child,
    );
  }
}
