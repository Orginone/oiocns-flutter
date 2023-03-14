import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/images.dart';
import 'package:orginone/widget/gy_scaffold.dart';
import 'package:timeline_tile/timeline_tile.dart';

import 'logic.dart';
import 'state.dart';

class ProcessDetailsPage
    extends BaseGetView<ProcessDetailsController, ProcessDetailsState> {
  @override
  Widget buildView() {
    return GyScaffold(
      titleName: "待办详情",
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _title(),
                    _basicInfo(),
                    _assetDetails(),
                    _timeLine(),
                    _annex(),
                    _opinion(),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 75.h,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _button(
                    text: '终止流程', textColor: Colors.white, color: Colors.red),
                _button(
                    text: '不同意',
                    textColor: XColors.themeColor,
                    border: Border.all(width: 0.5, color: XColors.themeColor)),
                _button(
                    text: '同意',
                    textColor: Colors.white,
                    color: XColors.themeColor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _title() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.w), color: Colors.white),
      padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                Images.defaultAvatar,
                width: 30.w,
                height: 30.w,
              ),
              SizedBox(
                width: 15.w,
              ),
              Text(
                "资产入账单",
                style: TextStyle(fontSize: 18.sp),
              ),
              SizedBox(
                width: 20.w,
              ),
              Text(
                "资产管理应用",
                style: TextStyle(color: Colors.grey, fontSize: 16.sp),
              ),
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          Text(
            "单据编号：ZCCZ20210316001128",
            style: TextStyle(color: Colors.grey, fontSize: 16.sp),
          ),
          SizedBox(
            height: 5.h,
          ),
          Text(
            "发起时间: 2023-03-14 16:26:49",
            style: TextStyle(color: Colors.grey, fontSize: 16.sp),
          ),
        ],
      ),
    );
  }

  Widget _basicInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.symmetric(vertical: 15.h),
            child: Text(
              "基本信息",
              style: TextStyle(color: Colors.black, fontSize: 20.sp),
            )),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.w),
          ),
          child:Column(
            children: [
              _text(title: '单据编号',content: "ZCCZ20210316001128"),
              _text(title: '处置方式',content: "无偿调拨（划转）"),
              _text(title: '申请单位',content: "资产云开放协同创新中心"),
              _text(title: '是否评估',content: "否"),
              _text(title: '累计折旧合计',content: "900"),
              _text(title: '净值合计',content: "0"),
              _text(title: '资产接收单位类型',content: "系统外（填备注）"),
              _text(title: '资产接收单位',content: ""),
              _text(title: '涉及资产总值',content: "960"),
              _text(title: '数量',content: "1"),
              _text(title: '基准日',content: ""),
              _text(title: '有效期',content: ""),
              _text(title: '产权交易机构',content: ""),
              _remake(title: "申请原因",content: "xxxxx"),
              _remake(title: "备注",content: "xxxxx"),
            ],
          )
        ),
      ],
    );
  }

  Widget _assetDetails(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.symmetric(vertical: 15.h),
            child: Text(
              "资产明细",
              style: TextStyle(color: Colors.black, fontSize: 20.sp),
            )),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.w),
            ),
            child:Column(
              children: [
                _text(title: '累计折旧',content: "960"),
                _text(title: '资产大类',content: "通用设备"),
                _text(title: '面积',content: ""),
                _text(title: '车牌号',content: ""),
                _text(title: '数量',content: "1"),
                _text(title: '取得日期',content: "2014-12-01"),
                _text(title: '原值',content: "960"),
                _text(title: '预计使用年限',content: "72"),
                _text(title: '型号规格',content: ""),
                _text(title: '净值',content: "0"),
                _text(title: '已使用期数',content: "79"),
                _text(title: '存放地点',content: ""),
                _text(title: '资产名称',content: "tttt"),
                _text(title: '品牌',content: ""),
                _text(title: '计量单位',content: ""),
                _text(title: '坐落位置',content: ""),
                _text(title: '资产分类',content: "投影仪"),
                _text(title: '资产编号',content: "ZCJJ2021011402389"),
              ],
            )
        ),
      ],
    );
  }

  Widget _timeLine() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.symmetric(vertical: 15.h),
            child: Text(
              "审批流程",
              style: TextStyle(color: Colors.black, fontSize: 20.sp),
            )),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.w),
          ),
          child: Obx(() {
            Widget hide = Container();

            int length = state.maxLength;

            if (state.hideProcess.value) {
              length = 2;
              hide = Container(
                width: double.infinity,
                height: 40.h,
                color: Colors.white.withOpacity(0.8),
                alignment: Alignment.center,
                child: GestureDetector(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 3.h),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.w),
                        border: Border.all(color: XColors.themeColor)),
                    child: Text(
                      "查看全部流程(${state.maxLength})>",
                      style:
                          TextStyle(color: XColors.themeColor, fontSize: 20.sp),
                    ),
                  ),
                  onTap: () {
                    controller.showAllProcess();
                  },
                ),
              );
            }

            return Stack(
              alignment: Alignment.bottomCenter,
              children: [
                ListView.builder(
                  itemCount: length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      child: _buildTimelineTile(index),
                    );
                  },
                ),
                hide,
              ],
            );
          }),
        ),
      ],
    );
  }

  Widget _annex() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.symmetric(vertical: 15.h),
            child: Text(
              "附件",
              style: TextStyle(color: Colors.black, fontSize: 20.sp),
            )),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.w),
            ),
            child: Container()),
      ],
    );
  }

  Widget _opinion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 15.h),
          child: Text(
            "审批意见",
            style: TextStyle(color: Colors.black, fontSize: 20.sp),
          ),
        ),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.w),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "意见",
                  style: TextStyle(color: Colors.black, fontSize: 20.sp),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(16.w)),
                  child: TextField(
                    maxLines: 4,
                    maxLength: 140,
                    decoration: InputDecoration(
                        hintText: "请输入您的意见",
                        hintStyle: TextStyle(
                            color: Colors.grey.shade200, fontSize: 24.sp),
                        border: InputBorder.none),
                  ),
                ),
              ],
            ),),
      ],
    );
  }

  Widget _buildTimelineTile(int index) {
    return TimelineTile(
        isFirst: index == 0 ? true : false,
        isLast: index == state.maxLength - 1 ? true : false,
        indicatorStyle: IndicatorStyle(
          width: 20.w,
          height: 20.w,
          color: XColors.themeColor,
          indicatorXY: 0,
        ),
        afterLineStyle:
            const LineStyle(thickness: 1, color: XColors.themeColor),
        beforeLineStyle:
            const LineStyle(thickness: 1, color: XColors.themeColor),
        endChild: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(TextSpan(children: [
                    TextSpan(
                      text: "经办人 ",
                      style: TextStyle(color: Colors.black, fontSize: 20.sp),
                    ),
                    TextSpan(
                      text: "星星",
                      style: TextStyle(color: Colors.grey, fontSize: 18.sp),
                    )
                  ])),
                  Text.rich(
                    TextSpan(children: [
                      TextSpan(
                        text: "流程: ",
                        style: TextStyle(color: Colors.black, fontSize: 16.sp),
                      ),
                      TextSpan(
                        text: "同意",
                        style: TextStyle(color: Colors.grey, fontSize: 16.sp),
                      )
                    ]),
                  ),
                  Text.rich(
                    TextSpan(children: [
                      TextSpan(
                        text: "意见: ",
                        style: TextStyle(color: Colors.black, fontSize: 16.sp),
                      ),
                      TextSpan(
                        text: "发起",
                        style: TextStyle(color: Colors.grey, fontSize: 16.sp),
                      )
                    ]),
                  ),
                  Text(
                    "2022-05-13 13:46:47",
                    style: TextStyle(color: Colors.grey, fontSize: 16.sp),
                  )
                ],
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("13750835892",
                          style:
                              TextStyle(color: Colors.black, fontSize: 18.sp)),
                      Text.rich(
                        TextSpan(children: [
                          TextSpan(
                            text: "流程节点: ",
                            style:
                                TextStyle(color: Colors.black, fontSize: 16.sp),
                          ),
                          TextSpan(
                            text: "发起",
                            style:
                                TextStyle(color: Colors.grey, fontSize: 16.sp),
                          )
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 20.w,
              ),
              Container(
                width: 25.w,
                height: 25.w,
                decoration: const BoxDecoration(
                    color: Colors.green, shape: BoxShape.circle),
                child: Icon(
                  Icons.done,
                  size: 20.w,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ));
  }

  Widget _text({required String title, String? content}) {
    return Container(
      margin: EdgeInsets.only(top: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.black, fontSize: 18.sp),
          ),
          Text(
            content ?? "",
            style: TextStyle(
                fontSize: 18.sp,
                color: Colors.black,
                fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }

  Widget _remake({String? title,String? content}){
    return    Container(
      margin: EdgeInsets.only(top: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title??"",
            style: TextStyle(color: Colors.black, fontSize: 20.sp),
          ),
          SizedBox(
            height: 10.h,
          ),
          Container(
              width: double.infinity,
              padding:
              EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(16.w)),
              child: Text(content??"")
          ),
        ],
      ),
    );
  }

  Widget _button(
      {VoidCallback? onTap,
      required String text,
      Color? textColor,
      Color? color,
      BoxBorder? border}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: 45.h,
        width: 140.w,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16.w),
          border: border,
        ),
        child: Text(
          text,
          style: TextStyle(color: textColor, fontSize: 20.sp),
        ),
      ),
    );
  }
}
