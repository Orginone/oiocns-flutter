import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/dart/core/getx/base_get_list_page_view.dart';
import 'package:orginone/pages/other/assets_config.dart';
import 'package:orginone/widget/common_widget.dart';

import 'item.dart';
import 'logic.dart';
import 'state.dart';

class AssetsPage extends BaseGetListPageView<AssetsController, AssetsState> {
  late AssetsListType assetsListType;

  late AssetsType assetsType;

  AssetsPage(this.assetsListType, this.assetsType);

  @override
  Widget buildView() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 10.h),
      child: Obx(() {
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            if (assetsType == AssetsType.myAssets) {
              return MyAssetsItem(
                assets: state.dataList[index],
              );
            }
            return CommonItem(
              assetUse: state.dataList[index],
              assetsListType: assetsListType,
              assetsType: assetsType,
            );
          },
          itemCount: state.dataList.length,
        );
      }),
    );
  }

  

  @override
  Widget headWidget() {
    String hint = "请输入${assetsType.name}单据编号";
    if (assetsType == AssetsType.check) {
      hint = "请输入盘点任务名称";
    }
    if(assetsType == AssetsType.myAssets){
      hint = "请输入资产编号";
    }

    return Column(
      children: [
        CommonWidget.commonSearchBarWidget(
          searchColor: Colors.white,
          backgroundColor:  XColors.themeColor,
          margin: EdgeInsets.only(left: 16.w,right: 16.w,bottom: 10.w),
          hint: hint,
          onChanged: (str){
            controller.search(str);
          }
        ),
        myAssetsInfo(),
      ],
    );
  }

  @override
  Widget bottomWidget() {
    // TODO: implement bottomWidget
    if (assetsType == AssetsType.check || assetsType == AssetsType.myAssets) {
      return Container();
    }

    return GestureDetector(
      onTap: () {
        controller.create(assetsType);
      },
      child: Container(
        height: 100.h,
        width: double.infinity,
        color: Colors.white,
        alignment: Alignment.center,
        child: Container(
          decoration: BoxDecoration(
            color: XColors.themeColor,
            borderRadius: BorderRadius.circular(4.w),
          ),
          width: 300.w,
          height: 50.h,
          alignment: Alignment.center,
          child: Text(
            "创建${assetsType.name}",
            style: TextStyle(color: Colors.white, fontSize: 20.sp),
          ),
        ),
      ),
    );
  }

  Widget myAssetsInfo() {
    if (assetsListType != AssetsListType.myAssets) {
      return Container();
    }
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
                    image: const DecorationImage(
                        image: NetworkImage(
                            "https://gysz-nk.oss-cn-hangzhou.aliyuncs.com/assetControl/app/totalValue-bg.png"),
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
                            child: Image.network(
                              "https://gysz-nk.oss-cn-hangzhou.aliyuncs.com/assetControl/app/totalValue-icon.png",
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
                        image: NetworkImage(
                            "https://gysz-nk.oss-cn-hangzhou.aliyuncs.com/assetControl/app/totalValue-bg.png"),
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
                          child: Image.network(
                            "https://gysz-nk.oss-cn-hangzhou.aliyuncs.com/assetControl/app/totalNum-icon.png",
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
          CommonWidget.commonHeadInfoWidget("资产列表",action: CommonWidget.commonIconButtonWidget(iconPath: "images/batch_operation_icon.png",callback: (){
            controller.jumpBatchAssets();
          },color: XColors.themeColor,tips: "批量操作"),padding: EdgeInsets.symmetric(vertical: 10.h)),
        ],
      ),
    );
  }

  @override
  AssetsController getController() {
    return AssetsController(assetsListType, assetsType);
  }

  @override
  String tag() {
    // TODO: implement tag
    return "${this.toString() + assetsListType.toString()}$hashCode";
  }
}
