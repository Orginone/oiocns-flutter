import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/model/assets_info.dart';
import 'package:orginone/pages/other/add_asset/state.dart';
import 'package:orginone/util/date_utils.dart';
import 'package:orginone/util/hive_utils.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/custom_paint.dart';

class Item extends StatelessWidget {
  final VoidCallback? openInfo;
  final VoidCallback? onTap;
  final bool showChoiceButton;
  final AssetsInfo assets;
  final ValueChanged<bool>? changed;
  final bool supportSideslip;
  final VoidCallback? delete;

  const Item(
      {Key? key,
      this.openInfo,
      this.showChoiceButton = false,
      required this.assets,
      this.changed,  this.supportSideslip = false, this.delete, this.onTap})
      : super(key: key);

  SettingController get settingController => Get.find<SettingController>();

  @override
  Widget build(BuildContext context) {

    Widget child = assets.isOpen ? open() : putAway();


    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(top: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child:  Slidable(
          key: const ValueKey("assets"),
          enabled: supportSideslip,
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                onPressed: (BuildContext context) {
                  if(delete!=null){
                    delete!();
                  }
                },
              ),
            ],
          ), child: child,
        ),
      ),
    );
  }

  Widget putAway() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.w),
          boxShadow: [BoxShadow(color: Colors.grey.shade400, blurRadius: 2.5)]),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
            decoration: BoxDecoration(
              color: Colors.lightBlueAccent.shade200,
              borderRadius: BorderRadius.vertical(top: Radius.circular(6.w)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                showChoiceButton?Container(
                  child: CommonWidget.commonMultipleChoiceButtonWidget(
                      isSelected: assets.isSelected, changed: changed),
                  margin: EdgeInsets.only(right: 10.w),
                ):Container(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            assets.assetName??"",
                            style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                          Text(
                            "x${assets.numOrArea??0}",
                            style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        children: [
                          Text(
                            "净值￥${assets.netVal??0}",
                            style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                          SizedBox(
                            width: 50.w,
                          ),
                          Text(
                            "原值￥${assets.netVal??0}",
                            style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(6.w)),
            ),
            margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 15.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  assets.assetCode??"",
                  style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade500),
                ),
                GestureDetector(
                  onTap: openInfo,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "展开",
                          style: TextStyle(color: Colors.blue, fontSize: 20.sp),
                        ),
                        WidgetSpan(
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            size: 32.w,
                            color: Colors.blue,
                          ),
                          alignment: PlaceholderAlignment.middle,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget open() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.blue, borderRadius: BorderRadius.circular(8.w)),
      padding: EdgeInsets.only(left: 5.w, right: 5.w, bottom: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              showChoiceButton?Container(
                child: CommonWidget.commonMultipleChoiceButtonWidget(
                    isSelected: assets.isSelected, changed: changed),
                margin: EdgeInsets.only(top: 15.h),
              ):Container(),
              Expanded(
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            assets.assetName??"",
                            style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                          Text(
                            "x${assets.numOrArea??0}",
                            style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          )
                        ],
                      ),
                      Stack(
                        children: [
                          Row(
                            children: [
                              Text(
                                "净值￥${assets.netVal??0}",
                                style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                              SizedBox(
                                width: 50.w,
                              ),
                              Text(
                                "原值￥${assets.netVal??0}",
                                style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              )
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: Container(
                                  color: Colors.white,
                                  height: 0.5.h,
                                )),
                                Container(
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 10.w),
                                  width: 45.w,
                                  height: 45.w,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            "https://gysz-nk.oss-cn-hangzhou.aliyuncs.com/assetControl/app/default-avatar.png")),
                                  ),
                                ),
                                Container(
                                  color: Colors.white,
                                  height: 0.5.h,
                                  width: 30.w,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  assets.assetCode??"",
                                  style: TextStyle(
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,overflow: TextOverflow.ellipsis),
                                  maxLines: 1,
                                ),
                                Text(
                                  "资产编号",
                                  style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  HiveUtils.getUser()?.userName??"",
                                  style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ),
                                // Text(
                                //   settingController.user?.name??"",
                                //   style: TextStyle(
                                //       fontSize: 20.sp,
                                //       fontWeight: FontWeight.w500,
                                //       color: Colors.white),
                                // ),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Material(
              shape: CustomTopBulgeShape(),
              color: Colors.white,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                    CommonWidget.commonTextContentWidget(
                        "取得日期", DateTime.tryParse(assets.quderq??"")?.format()??""),
                    CommonWidget.commonTextContentWidget("规格型号", assets.specMod??""),
                    CommonWidget.commonTextContentWidget("品牌", assets.brand??""),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 15.h),
                      child: GestureDetector(
                        onTap: openInfo,
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "收起",
                                style: TextStyle(
                                    color: Colors.blue, fontSize: 20.sp),
                              ),
                              WidgetSpan(
                                child: Icon(
                                  Icons.keyboard_arrow_up_outlined,
                                  size: 32.w,
                                  color: Colors.blue,
                                ),
                                alignment: PlaceholderAlignment.middle,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
