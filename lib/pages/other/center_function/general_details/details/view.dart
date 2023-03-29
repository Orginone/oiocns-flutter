import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/dart/core/getx/base_get_page_view.dart';
import 'package:orginone/images.dart';
import 'package:orginone/model/assets_info.dart';
import 'package:orginone/pages/other/assets_config.dart';
import 'package:orginone/pages/other/center_function/assets_check/check/state.dart';
import 'package:orginone/pages/other/center_function/general_details/details/asset_description.dart';
import 'package:orginone/pages/other/center_function/general_details/logic.dart';
import 'package:orginone/pages/other/center_function/general_details/state.dart';
import 'package:orginone/util/date_utils.dart';
import 'package:orginone/util/department_management.dart';
import 'package:orginone/util/hive_utils.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/custom_paint.dart';

import 'logic.dart';
import 'state.dart';

class DetailsPage extends BaseGetPageView<DetailsController, DetailsState> {
  final AssetsType assetsType;

  DetailsPage(this.assetsType);

  GeneralDetailsController get detailsController =>
      Get.find<GeneralDetailsController>();

  GeneralDetailsState get dstate => detailsController.state;

  @override
  Widget buildView() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                headInfo(),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return detailedInfo(items(index + 1,
                        dstate.assetUse!.approvalDocument!.detail![index]));
                  },
                  itemCount:
                  dstate.assetUse?.approvalDocument?.detail?.length ?? 0,
                ),
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
          return Row(
            children: [
              Image.asset(
                Images.rmbIcon,
                width: 20.w,
                height: 20.h,
              ),
              SizedBox(
                width: 10.w,
              ),
              Text(
                "${dstate.assets!.netVal ?? 0}",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500),
              ),
            ],
          );
        case AssetsType.claim:
          return AssetDescription.claimDescription(dstate);
        case AssetsType.subscribe:
          return Container();
        case AssetsType.dispose:
          return AssetDescription.disposeDescription(dstate);
        case AssetsType.transfer:
          return AssetDescription.transferDescription(dstate);
        case AssetsType.borrow:
          return Container();
        case AssetsType.revert:
          return Container();
        case AssetsType.handOver:
          return AssetDescription.handOverDescription(dstate);
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
                    Text(dstate.assetUse?.approvalDocument?.createTime
                        ?.format(format: "yyyy-MM-DD HH:mm:ss") ??
                        ""),
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
                          assetsType == AssetsType.check
                              ? dstate.assets?.assetCode ?? ""
                              : dstate.assetUse?.billCode ?? "",
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
                        Image.asset(
                          Images.defaultAvatar,
                          width: 32.w,
                          height: 32.h,
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          assetsType == AssetsType.check ? "领用人" : "提交人",
                          style: TextStyle(color: Colors.grey, fontSize: 18.sp),
                        ),
                        Text(
                          assetsType == AssetsType.check
                              ? (dstate.assets!.userName ?? "")
                              : (dstate.assetUse?.oldUserId ?? dstate.assetUse?.submitterName??""),
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
    return Column(
      children: [
        detailedInfo(
          items(0, dstate.assets!),
        ),
        SizedBox(
          height: 10.h,
        ),
        detailedInfo([
          CommonWidget.commonTextContentWidget(
              "GS1编号", dstate.assets!.gs1 ?? ""),
          CommonWidget.commonTextContentWidget("财务同步状态", ""),
          CommonWidget.commonTextContentWidget(
              "资产原值", "${dstate.assets!.netVal ?? 0}"),
          CommonWidget.commonTextContentWidget("取得日期",
              DateTime.tryParse(dstate.assets!.quderq ?? "")?.format() ?? ""),
          CommonWidget.commonTextContentWidget(
              "数量", "${dstate.assets!.numOrArea ?? 0}"),
          CommonWidget.commonTextContentWidget(
              "品牌", dstate.assets!.brand ?? ""),
          CommonWidget.commonTextContentWidget(
              "规格型号", dstate.assets!.specMod ?? ""),
          CommonWidget.commonTextContentWidget(
              "存放地点", dstate.assets!.location ?? ""),
          CommonWidget.commonTextContentWidget("取得方式", ""),
          CommonWidget.commonTextContentWidget(
              "预计使用期限(月)", dstate.assets!.minimumLimit ?? ""),
        ]),
      ],
    );
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

  List<Widget> items(int index,AssetsInfo assets) {
    switch (assetsType) {
      case AssetsType.check:
        return [
          CommonWidget.commonTextContentWidget("资产编号", assets.assetCode ?? ""),
          CommonWidget.commonTextContentWidget("资产名称", assets.assetName ?? ""),
          CommonWidget.commonTextContentWidget(
              "资产分类", assets.assetType ?? ""),
        ];
      case AssetsType.claim:
        return [
          Text(
            "申请明细$index",
            style: TextStyle(
                color: Colors.black,
                fontSize: 20.sp,
                fontWeight: FontWeight.w500),
          ),
          CommonWidget.commonTextContentWidget("资产分类", assets.assetType??""),
          CommonWidget.commonTextContentWidget("资产名称", assets.assetName??""),
          CommonWidget.commonTextContentWidget("领用人和部门",  "${HiveUtils
              .getUser()
              ?.userName ?? ""}-${DepartmentManagement().currentDepartment?.name ??
              ""}"),
          CommonWidget.commonTextContentWidget("数量", "${assets.numOrArea??0}"),
          CommonWidget.commonTextContentWidget("规格型号", assets.specMod??""),
          CommonWidget.commonTextContentWidget("品牌", assets.brand??""),
          CommonWidget.commonTextContentWidget("存放地点", assets.location??""),
          CommonWidget.commonTextContentWidget("是否信创", assets.isDistribution==null?"":assets.isDistribution!?"是":"否"),
        ];
      case AssetsType.dispose:
        return [
          Text(
            "处置明细$index",
            style: TextStyle(
                color: Colors.black,
                fontSize: 20.sp,
                fontWeight: FontWeight.w500),
          ),
          CommonWidget.commonTextContentWidget("资产编号", assets.assetCode ?? ""),
          CommonWidget.commonTextContentWidget("资产名称", assets.assetName ?? ""),
          CommonWidget.commonTextContentWidget(
              "资产分类", assets.userName ?? ""),
          CommonWidget.commonTextContentWidget("原值", "￥${assets.netVal ?? 0}"),
          CommonWidget.commonTextContentWidget(
              "数量", "${assets.numOrArea ?? 0}"),
          CommonWidget.commonTextContentWidget(
              "取得日期", DateTime.tryParse(assets.quderq ?? "")?.format() ?? ""),
          CommonWidget.commonTextContentWidget("规格型号", assets.specMod ?? ""),
          CommonWidget.commonTextContentWidget("品牌", assets.brand ?? ""),
        ];
      case AssetsType.transfer:
        return [
          Text(
            "移交明细$index",
            style: TextStyle(
                color: Colors.black,
                fontSize: 20.sp,
                fontWeight: FontWeight.w500),
          ),
          CommonWidget.commonTextContentWidget("资产编号", assets.assetCode??""),
          CommonWidget.commonTextContentWidget("资产名称", assets.assetName??""),
          CommonWidget.commonTextContentWidget("资产分类", assets.userName??""),
          CommonWidget.commonTextContentWidget("数量", "${assets.numOrArea??0}"),
          CommonWidget.commonTextContentWidget("规格型号", assets.specMod??""),
          CommonWidget.commonTextContentWidget("品牌", assets.brand??""),
          CommonWidget.commonTextContentWidget("存放地点", assets.location??""),
        ];
      case AssetsType.handOver:
        return [
          Text(
            "交回明细$index",
            style: TextStyle(
                color: Colors.black,
                fontSize: 20.sp,
                fontWeight: FontWeight.w500),
          ),
          CommonWidget.commonTextContentWidget("资产编号", assets.assetCode ?? ""),
          CommonWidget.commonTextContentWidget("资产名称", assets.assetName ?? ""),
          CommonWidget.commonTextContentWidget(
              "资产分类", assets.userName ?? ""),
          CommonWidget.commonTextContentWidget(
              "数量", "${assets.numOrArea ?? 0}"),
          CommonWidget.commonTextContentWidget("规格型号", assets.specMod ?? ""),
          CommonWidget.commonTextContentWidget("品牌", assets.brand ?? ""),
          CommonWidget.commonTextContentWidget("存放地点", assets.location ?? ""),
          CommonWidget.commonTextContentWidget(
              "原使用人", dstate.assetUse?.submitterName ?? ""),
        ];
      default:
        return <Widget>[];
    }
  }

  Widget bottomButton() {
    switch (assetsType) {
      case AssetsType.handOver:
        return Container();
        return CommonWidget.commonSubmitWidget(text: "重新提交");
      case AssetsType.check:
        if (dstate.assets!.status != 0) {
          return Container();
        }
        return CommonWidget.commonMultipleSubmitWidget(
            str1: "盘亏",
            str2: "盘存",
            onTap1: () {
              controller.inventory(CheckType.loss);
            },
            onTap2: () {
              controller.inventory(CheckType.saved);
            });
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
