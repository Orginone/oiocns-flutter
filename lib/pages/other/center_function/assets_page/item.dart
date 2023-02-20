import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/pages/other/assets_config.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/widget/custom_paint.dart';

class CommonItem extends StatelessWidget {
  final AssetsListType assetsListType;

  final AssetsType assetsType;

  const CommonItem(this.assetsListType, this.assetsType, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (assetsListType == AssetsListType.check) {
          Get.toNamed(Routers.assetsCheck);
        } else if (assetsListType != AssetsListType.draft) {
          Get.toNamed(Routers.generalDetails,
              arguments: {"AssetsType": assetsType});
        } else {
          Get.toNamed(assetsType.createRoute, arguments: {"isEdit": true});
        }
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
              child:statusInfo(),
            )
          ],
        ),
      ),
    );
  }

  Widget statusInfo(){
    if (AssetsListType.draft == assetsListType ||
        AssetsListType.myGoods == assetsListType) {
      return Container();
    }
    if (AssetsListType.myAssets == assetsListType) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Get.toNamed(Routers.createDispose);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 8.w),
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(4.w)),
              child: Column(
                children: [
                  Icon(
                    Icons.add_home,
                    size: 20.w,
                  ),
                  Text(
                    "处置",
                    style: TextStyle(fontSize: 16.sp),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
          GestureDetector(
            onTap: () {
              Get.toNamed(Routers.createTransfer);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 8.w),
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(4.w)),
              child: Column(
                children: [
                  Icon(
                    Icons.add_home,
                    size: 20.w,
                  ),
                  Text("移交", style: TextStyle(fontSize: 16.sp))
                ],
              ),
            ),
          )
        ],
      );
    }
    return CustomPaint(
      painter: CustomAssetsListItemButton(Colors.deepOrangeAccent),
      size: Size(100.w, 40.h),
      child: Container(
          width: 100.w,
          height: 40.h,
          alignment: Alignment.center,
          child: Text(
            "退回",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.sp,
            ),
          )),
    );
  }

  Widget taskInfo(){
    String title = "单据编号";
    String content = "xxxxxxxxxxxxxxxx";
    Widget status = Container();
    if(assetsListType == AssetsListType.check){
      title = "盘点任务";
      content = "111";
      status = Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        margin: EdgeInsets.only(left: 5.w),
        decoration: BoxDecoration(
          color: XColors.themeColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(2.w),
        ),
        child: Text("进行中",style: TextStyle(color: XColors.themeColor,fontSize: 14.sp),),
      );
    }
    return  Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
          borderRadius:
          BorderRadius.vertical(top: Radius.circular(8.w))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyle(
                    color: XColors.themeColor,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500),
              ),
              status,
              const Expanded(child: Align(child: Text("02/13 09:21:23",),alignment: Alignment.centerRight,)),
            ],
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

  Widget otherInfo(){
    Widget child = Row(
      children: [
        Image.network(
          "https://gysz-nk.oss-cn-hangzhou.aliyuncs.com/assetControl/app/default-avatar1.png",
          width: 20.w,
          height: 20.h,
        ),
        SizedBox(
          width: 10.w,
        ),
        Text(
          "领用人-xxx",
          style: TextStyle(
              color: Colors.black,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500),
        ),
      ],
    );
    if(assetsListType == AssetsListType.check){
      child = Text("xxxxxxxxxxx",style: TextStyle(color: Colors.grey.shade500,fontSize: 16.sp),);
    }
    return Container(
      padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 10.h),
      child: child,
    );
  }
}

class MyAssetsItem extends StatelessWidget {
  const MyAssetsItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routers.asstesDetails);
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
              right: 80.w,
              child: statusInfo(),
            )
          ],
        ),
      ),
    );
  }

  Widget statusInfo() {
    if(false){//资产变动逻辑
      return Container();
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Get.toNamed(Routers.createDispose);
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 8.w),
            decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(4.w)),
            child: Column(
              children: [
                Icon(
                  Icons.add_home,
                  size: 20.w,
                ),
                Text(
                  "处置",
                  style: TextStyle(fontSize: 16.sp),
                )
              ],
            ),
          ),
        ),
        SizedBox(
          width: 10.w,
        ),
        GestureDetector(
          onTap: () {
            Get.toNamed(Routers.createTransfer);
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 8.w),
            decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(4.w)),
            child: Column(
              children: [
                Icon(
                  Icons.add_home,
                  size: 20.w,
                ),
                Text("移交", style: TextStyle(fontSize: 16.sp))
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget taskInfo() {
    Widget status = Container();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(8.w))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "测试1",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w500),
              ),
              status,
              Expanded(
                  child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "x1",
                  style: TextStyle(
                      color: XColors.themeColor,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500),
                ),
              )),
            ],
          ),
          SizedBox(
            height: 5.h,
          ),
          Text(
            "xxxxxxxxxxxxxxxx",
            style: TextStyle(
              color: Colors.grey.shade300,
              fontSize: 20.sp,
            ),
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
          width: 5.w,
        ),
        Text(
          "100",
          style: TextStyle(
              color: Colors.black,
              fontSize: 16.sp,
          ),
        ),
      ],
    );
    return Container(
      padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 10.h),
      child: child,
    );
  }
}
