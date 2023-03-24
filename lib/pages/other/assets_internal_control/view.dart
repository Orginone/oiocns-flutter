import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/dart/core/getx/base_get_list_page_view.dart';
import 'package:orginone/images.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/widget/common_widget.dart';

import '../center_function/assets_page/item.dart';
import 'logic.dart';
import 'state.dart';

class AssetsInternalControlPage extends BaseGetListPageView<AssetsInternalControlController,AssetsInternalControlState>{
  @override
  Widget buildView() {
    return Container(
      height: double.infinity,
      color: Colors.grey.shade200,
      child: SingleChildScrollView(
        child: Column(
          children: [
            function(),
            myAssetsInfo(),
            ...state.dataList.map((element) => MyAssetsItem(assets: element,)).toList()
          ],
        ),
      ),
    );
  }

  Widget function(){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.w),
        color: Colors.white
      ),
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 25.h,bottom: 15.h),
      margin: EdgeInsets.symmetric(vertical: 10.h,horizontal: 16.w),
      child: GridView.count(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        crossAxisCount: 4,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.w,
        childAspectRatio:4/3,
        children: items.map((item) {
          return GestureDetector(
            onTap: () {
              Get.toNamed(Routers.centerFunction, arguments: {"info": item});
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 50.w,
                  height: 50.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(40.w)),
                    color: Colors.white,
                  ),
                  child: Image.network(item.iconUrl,),
                ),
                Container(
                  margin: EdgeInsets.only(top: 6.5.w),
                  child: Text(item.name, style: XFonts.size18Black3),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget myAssetsInfo() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 75.w,
                  decoration: BoxDecoration(
                    image:  const DecorationImage(
                        image: AssetImage(
                            Images.totalValueBg),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(4.w),
                  ),
                  child: Container(
                    margin: EdgeInsets.only(top: 10.h, left: 10.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            margin: EdgeInsets.only(
                                top: 5.h
                            ),
                            child: Image.asset(
                              Images.totalValueIcon,
                              width: 16.w,
                              height: 16.w,
                            )),
                        Container(
                          margin: EdgeInsets.only(left: 5.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("资产总值",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w500)),
                              Obx(() {
                                double grossValue = 0;
                                for (var element in state.dataList) {
                                  grossValue += element.netVal ?? 0;
                                }
                                return Text(
                                  "$grossValue",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.w500),
                                );
                              }),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                child: Container(
                  height: 75.w,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                        image: AssetImage(
                            Images.totalValueBg),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(4.w),
                  ),
                  child: Container(
                    margin: EdgeInsets.only(top: 10.h, left: 10.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              top: 5.h
                          ),
                          child: Image.asset(
                            Images.totalNumIcon,
                            width: 16.w,
                            height: 16.w,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 5.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("资产数量",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w500)),
                              Obx(() {
                                int count = 0;
                                for (var element in state.dataList) {
                                  count +=
                                  (int.tryParse(element.numOrArea.toString()) ?? 0);
                                }
                                return Text(
                                  "$count",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.w500),
                                );
                              }),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          CommonWidget.commonHeadInfoWidget("我的资产",
              action: CommonWidget.commonIconButtonWidget(
                  iconPath: Images.batchOperationIcon,
                  callback: () {
                    controller.jumpBatchAssets();
                  },
                  color: XColors.themeColor,
                  tips: "批量处理"),
              padding: EdgeInsets.symmetric(vertical: 10.h)),
        ],
      ),
    );
  }


  @override
  AssetsInternalControlController getController() {
    return AssetsInternalControlController();
  }

  @override
  String tag() {
    // TODO: implement tag
    return this.toString();
  }
}
