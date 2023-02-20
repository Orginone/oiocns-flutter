import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/dart/core/getx/base_get_page_view.dart';
import 'package:orginone/pages/other/assets_config.dart';
import 'package:orginone/pages/other/center_function/general_details/details/asset_description.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/custom_paint.dart';

import 'logic.dart';
import 'state.dart';

class DetailsPage extends BaseGetPageView<DetailsController, DetailsState> {
  final AssetsType assetsType;

  DetailsPage(this.assetsType);

  @override
  Widget buildView() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                headInfo(),
                detailedInfo(items),
                checkDetailedInfo(),
              ],
            ),
          ),
        ),
        bottomButton(),
      ],
    );
  }

  Widget headInfo() {
    Widget extraInfo() {
      switch (assetsType) {
        case AssetsType.myAssets:
          return Container();
        case AssetsType.approve:
          return Container();
        case AssetsType.check:
          return Container();
        case AssetsType.claim:
          return AssetDescription.claimDescription();
        case AssetsType.subscribe:
          return Container();
        case AssetsType.dispose:
          return AssetDescription.disposeDescription();
        case AssetsType.transfer:
          return AssetDescription.transferDescription();
        case AssetsType.borrow:
          return Container();
        case AssetsType.revert:
          return Container();
        case AssetsType.handOver:
          return AssetDescription.handOverDescription();
        case AssetsType.store:
          return Container();
        case AssetsType.more:
          return Container();
      }
    }

    return Container(
      width: double.infinity,
      color: XColors.themeColor,
      child: Container(
        margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 20.h),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(5.w)),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          WidgetSpan(
                            child: Container(
                              width: 15.w,
                              height: 15.w,
                              margin: EdgeInsets.only(right: 10.w),
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.green),
                            ),
                            alignment: PlaceholderAlignment.middle,
                          ),
                          TextSpan(
                            text: "基本信息",
                            style:
                                TextStyle(color: Colors.green, fontSize: 20.sp),
                          )
                        ],
                      ),
                    ),
                    const Text("2023-01-05 12:21:22"),
                  ],
                ),
              ),
              Container(
                color: Colors.blue.shade50,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "xxxxxxxxx",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 25.sp,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          assetsType == AssetsType.check ? "资产编号" : "单据编号",
                          style: TextStyle(color: Colors.grey, fontSize: 18.sp),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          "https://gysz-nk.oss-cn-hangzhou.aliyuncs.com/assetControl/app/default-avatar1.png",
                          width: 32.w,
                          height: 32.h,
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          "提交人",
                          style: TextStyle(color: Colors.grey, fontSize: 18.sp),
                        ),
                        Text(
                          "芳",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 25.sp,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
                  child: extraInfo()),
            ],
          ),
        ),
      ),
    );
  }

  Widget checkDetailedInfo() {
    if (assetsType != AssetsType.check) {
      return Container();
    }
    return detailedInfo([
      CommonWidget.commonTextContentWidget("GS1编号", ""),
      CommonWidget.commonTextContentWidget("财务同步状态", ""),
      CommonWidget.commonTextContentWidget("资产原值", ""),
      CommonWidget.commonTextContentWidget("取得日期", ""),
      CommonWidget.commonTextContentWidget("数量", ""),
      CommonWidget.commonTextContentWidget("品牌", ""),
      CommonWidget.commonTextContentWidget("规格型号", ""),
      CommonWidget.commonTextContentWidget("存放地点", ""),
      CommonWidget.commonTextContentWidget("取得方式", ""),
      CommonWidget.commonTextContentWidget("预计使用期限(月)", ""),
    ]);
  }

  Widget detailedInfo(List<Widget> items) {
    return Container(
      margin: EdgeInsets.only(top: 15.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Material(
        shape: CustomTopNotchShape(),
        color: Colors.white,
        child: Container(
          margin: EdgeInsets.only(top: 20.h),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          width: double.infinity,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, children: items),
        ),
      ),
    );
  }

  List<Widget> get items {
    switch (assetsType) {
      case AssetsType.check:
        return [
          CommonWidget.commonTextContentWidget("资产编号", "xxxxxxxx"),
          CommonWidget.commonTextContentWidget("资产分类", "xxxx"),
          CommonWidget.commonTextContentWidget("资产名称", "xxx"),
        ];
      case AssetsType.claim:
        return [
          Text(
            "申请明细1",
            style: TextStyle(
                color: Colors.black,
                fontSize: 20.sp,
                fontWeight: FontWeight.w500),
          ),
          CommonWidget.commonTextContentWidget("资产分类", "对讲机"),
          CommonWidget.commonTextContentWidget("资产明细", "对讲机"),
          CommonWidget.commonTextContentWidget("领用人和部门", "芳-测试部"),
          CommonWidget.commonTextContentWidget("数量", "0"),
          CommonWidget.commonTextContentWidget("规格型号", ""),
          CommonWidget.commonTextContentWidget("品牌", ""),
          CommonWidget.commonTextContentWidget("存放地点", ""),
          CommonWidget.commonTextContentWidget("是否信创", ""),
        ];
        break;
      case AssetsType.dispose:
        return [
          Text(
            "处置明细1",
            style: TextStyle(
                color: Colors.black,
                fontSize: 20.sp,
                fontWeight: FontWeight.w500),
          ),
          CommonWidget.commonTextContentWidget("资产编号", "xxxxxxxx"),
          CommonWidget.commonTextContentWidget("资产名称", "xxx"),
          CommonWidget.commonTextContentWidget("资产分类", "xxxx"),
          CommonWidget.commonTextContentWidget("原值", "￥0"),
          CommonWidget.commonTextContentWidget("数量", "0"),
          CommonWidget.commonTextContentWidget("取得日期", ""),
          CommonWidget.commonTextContentWidget("规格型号", ""),
          CommonWidget.commonTextContentWidget("品牌", ""),
        ];
        break;
      case AssetsType.transfer:
        return [
          Text(
            "移交明细1",
            style: TextStyle(
                color: Colors.black,
                fontSize: 20.sp,
                fontWeight: FontWeight.w500),
          ),
          CommonWidget.commonTextContentWidget("资产编号", "xxxxxxxx"),
          CommonWidget.commonTextContentWidget("资产名称", "xxx"),
          CommonWidget.commonTextContentWidget("资产分类", "xxxx"),
          CommonWidget.commonTextContentWidget("数量", "0"),
          CommonWidget.commonTextContentWidget("规格型号", ""),
          CommonWidget.commonTextContentWidget("品牌", ""),
          CommonWidget.commonTextContentWidget("存放地点", ""),
        ];
        break;
      case AssetsType.handOver:
        return [
          Text(
            "交回明细1",
            style: TextStyle(
                color: Colors.black,
                fontSize: 20.sp,
                fontWeight: FontWeight.w500),
          ),
          CommonWidget.commonTextContentWidget("资产编号", "xxxxxxxx"),
          CommonWidget.commonTextContentWidget("资产名称", "xxx"),
          CommonWidget.commonTextContentWidget("资产分类", "xxxx"),
          CommonWidget.commonTextContentWidget("数量", "0"),
          CommonWidget.commonTextContentWidget("规格型号", ""),
          CommonWidget.commonTextContentWidget("品牌", ""),
          CommonWidget.commonTextContentWidget("存放地点", ""),
          CommonWidget.commonTextContentWidget("原使用人", ""),
        ];
      default:
        return <Widget>[];
    }
  }

  Widget bottomButton() {
    switch (assetsType) {
      case AssetsType.handOver:
        return CommonWidget.commonSubmitWidget(text: "重新提交");
      case AssetsType.check:
        return CommonWidget.commonMultipleSubmitWidget(str1: "盘亏",str2: "盘存");
      default:
        return Container();
    }
  }

  @override
  DetailsController getController() {
    return DetailsController();
  }

  @override
  String tag() {
    // TODO: implement tag
    return this.toString();
  }
}
