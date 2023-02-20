import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/pages/other/assets_config.dart';

import 'logic.dart';
import 'state.dart';

class ApproveDocumentsPage
    extends BaseGetView<ApproveDocumentsController, ApproveDocumentsState> {
  @override
  Widget buildView() {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: const Text("审批单据"),
        backgroundColor: XColors.themeColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
                  child: Column(
                    children: [
                      DocumentsInfo(),
                      detailed(),
                      stepper(),
                      opinion(),
                    ],
                  ),
                ),
              ),
            ),
            bottomButton(),
          ],
        ),
      ),
    );
  }

  Widget DocumentsInfo() {
    List<Widget> content = [
      info("单据编号", "xxxxx"),
      info("提交时间", "xxxx"),
      info("提交人", "xxxx"),
      info("审批状态", "xxxxx"),
    ];

    switch (state.type) {
      case DocumentsType.transfer:
        content.addAll([
          info("移交人", "xxxx"),
          info("移交至人员", "xxxx"),
          info("申请事由", "xxxx", interval: false),
        ]);
        break;
      case DocumentsType.change:
        content.addAll([
          info("资产编号", "xxxx"),
          info("资产名称", "xxxx"),
          info("财政同步状态", "xxxx"),
          info("变更类型", "xxxx"),
          info("变更原因", "xxxx", interval: false),
        ]);
        break;
      case DocumentsType.management:
        content.addAll([
          info("处理方式", "xxxx"),
          info("资产接收单位类型", "xxxx"),
          info("资产接收单位名称", "xxxx"),
          info("资产接收单位号码", "xxxx"),
          info("涉及资产总值", "xxxx"),
          info("处理方式", "xxxx"),
          info("净值合计", "xxxx"),
          info("数量", "xxxx"),
          info("申请原因", "xxxx"),
          info("审批端", "xxxx", interval: false),
        ]);
        break;
      case DocumentsType.apply:
        content.add(info("申请事由", "xxxx", interval: false));
        break;
      case DocumentsType.buy:
        content.add(info("申请事由", "xxxx", interval: false));
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "单据类型:${state.type.name}",
          style: TextStyle(
              fontWeight: FontWeight.w700, fontSize: 20.sp),
        ),
        shell(
            child: Column(
          children: content,
        )),
      ],
    );
  }

  Widget detailed() {
    Widget name = Text(
      "电脑",
      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 26.sp),
    );

    if (state.type == DocumentsType.change) {
      name = Container();
    }

    List<Widget> content = [];

    Widget changeWidget() {
      return shell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            info("变更字段名称", "XXXXXXXX"),
            info("变更前值", "XXXXXXXX"),
            info("变更后值", "XXXXXXXX", interval: false),
          ],
        ),
      );
    }

    switch (state.type) {
      case DocumentsType.transfer:
        content = [
          name,
          SizedBox(
            height: 40.h,
            width: double.infinity,
            child: Row(
              children: [
                Expanded(child: info("数量", "111")),
                Expanded(
                  child: info("原值", "111"),
                  flex: 2,
                ),
              ],
            ),
          ),
          info("资产编号", "XXXXXXXX"),
          info("资产名称", "XXXXXXXX"),
          info("资产分类", "XXXXXXXX"),
          info("原值", "XXXXXXXX"),
          info("数量", "XXXXXXXX"),
          info("存放地点", "XXXXXXXX"),
          info("取得方式", "XXXXXXXX"),
          info("使用部门", "XXXXXXXX"),
          info("使用人", "XXXXXXXX", interval: false, showMoreButton: true),
        ];
        break;
      case DocumentsType.management:
        content = [
          name,
          SizedBox(
            height: 40.h,
            width: double.infinity,
            child: Row(
              children: [
                Expanded(child: info("数量", "111")),
                Expanded(
                  child: info("原值", "111"),
                  flex: 2,
                ),
              ],
            ),
          ),
          info("资产编号", "XXXXXXXX"),
          info("资产名称", "XXXXXXXX"),
          info("资产分类", "XXXXXXXX"),
          info("原值", "XXXXXXXX"),
          info("单位", "XXXXXXXX"),
          info("数量", "XXXXXXXX"),
          info("取得方式", "XXXXXXXX"),
          info("品牌", "XXXXXXXX"),
          info("规格型号", "XXXXXXXX", interval: false, showMoreButton: true),
        ];
        break;
      case DocumentsType.apply:
        content = [
          name,
          SizedBox(
            height: 40.h,
            width: double.infinity,
            child: Row(
              children: [
                Expanded(child: info("数量", "111")),
                Expanded(
                  child: info("品牌", "111"),
                  flex: 2,
                ),
              ],
            ),
          ),
          info("规格型号", "XXXXXXXX"),
          info("资产分类", "XXXXXXXX"),
          info("资产名称", "XXXXXXXX"),
          info("领用人", "XXXXXXXX"),
          info("领用部门", "XXXXXXXX"),
          info("单位", "XXXXXXXX"),
          info("数量", "XXXXXXXX"),
          info("品牌", "XXXXXXXX"),
          info("存放地点", "XXXXXXXX", interval: false, showMoreButton: true),
        ];
        break;
      case DocumentsType.buy:
        content = [
          name,
          SizedBox(
            height: 40.h,
            width: double.infinity,
            child: Row(
              children: [
                Expanded(child: info("数量", "111")),
                Expanded(
                  child: info("品牌", "111"),
                  flex: 2,
                ),
              ],
            ),
          ),
          info("规格型号", "XXXXXXXX"),
          info("资产分类", "XXXXXXXX"),
          info("资产名称", "XXXXXXXX"),
          info("经费编号", "XXXXXXXX"),
          info("品牌", "XXXXXXXX"),
          info("存放地点", "XXXXXXXX"),
          info("申购人", "XXXXXXXX"),
          info("申购部门", "XXXXXXXX"),
          info("数量", "XXXXXXXX", interval: false, showMoreButton: true),
        ];
        break;
    }

    Widget child = Obx(() {
      List<Widget> children = [];
      if (!state.showMore.value) {
        children.add(content[0]);
        children.add(content[1]);
        children.add(content[content.length - 1]);
      } else {
        children.addAll(content);
      }
      return shell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      );
    });

    if (state.type == DocumentsType.change) {
      child = Column(
        children: [
          changeWidget(),
          changeWidget(),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 8.h,
        ),
        Text(
          state.type.detailed,
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20.sp),
        ),
        child,
      ],
    );
  }

  Widget stepper() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 8.h,
        ),
        Text(
          "审批流程",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20.sp),
        ),
        shell(
          child: Stepper(
            physics: const NeverScrollableScrollPhysics(),
            elevation: 0,
            currentStep: 1,
            margin: EdgeInsets.zero,
            steps: [
              Step(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '张三(发起人)',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                      Text(
                        '01-21 21:32:21',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '资产管理员',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                      Text(
                        '备注:xxxxxx',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ],
                  ),
                  state: StepState.complete,
                  content: Container(),
                  isActive: true),
              Step(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '李四(已同意)',
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    Text(
                      '01-21 21:32:21',
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '资产管理员',
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    Text(
                      '备注:xxxxxx',
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  ],
                ),
                state: StepState.complete,
                content: Container(),
                isActive: true,
              ),
              Step(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '王五(处理中)',
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    Text(
                      '01-21 21:32:21',
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '资产管理员',
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    Text(
                      '备注:xxxxxx',
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  ],
                ),
                state: StepState.indexed,
                content: Container(),
              ),
            ],
            controlsBuilder: (context, details) {
              return Container();
            },
          ),
        ),
      ],
    );
  }

  Widget opinion() {
    if(!state.edit){
      return Container();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 8.h,
        ),
        Text(
          "审批意见",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20.sp),
        ),
        shell(
            child: TextField(
          controller: state.textEditingController,
          decoration: const InputDecoration(
              border: InputBorder.none, isDense: true, hintText: "请输入您的意见"),
          maxLines: 10,
        )),
      ],
    );
  }

  Widget bottomButton() {
    if(!state.edit){
      return Container();
    }
    return Container(
      width: double.infinity,
      height: 100.h,
      decoration: BoxDecoration(
        color: Colors.white,
        border:
            Border(top: BorderSide(color: Colors.grey.shade400, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: 100.w,
            height: 50.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400, width: 0.5),
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.w)),
            child: const Text("退回"),
          ),
          Container(
            width: 100.w,
            height: 50.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400, width: 0.5),
                color: Colors.red,
                borderRadius: BorderRadius.circular(16.w)),
            child: const Text(
              "不同意",
              style: TextStyle(color: Colors.white),
            ),
          ),
          Container(
            width: 100.w,
            height: 50.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400, width: 0.5),
                color: Colors.green,
                borderRadius: BorderRadius.circular(16.w)),
            child: const Text(
              "同意",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget shell({required Widget child}) {
    return Container(
      margin: EdgeInsets.only(top: 10.h),
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.w),
      ),
      child: child,
    );
  }

  Widget info(String title, String subText,
      {bool interval = true, bool showMoreButton = false}) {
    return Container(
      margin: EdgeInsets.only(bottom: interval ? 4.h : 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18.sp, color: Colors.black38),
          ),
          Text(
            ":",
            style: TextStyle(fontSize: 18.sp, color: Colors.black38),
          ),
          Expanded(
            child: Text(
              subText,
              style: TextStyle(fontSize: 18.sp, color: Colors.black),
            ),
          ),
          showMoreButton
              ? GestureDetector(
                  onTap: () {
                    controller.showMore();
                  },
                  child: Text.rich(TextSpan(children: [
                    TextSpan(
                      text: "资产详情",
                      style:
                          TextStyle(fontSize: 18.sp, color: Colors.blueAccent),
                    ),
                    WidgetSpan(
                        child: Obx(() {
                          return Icon(
                            state.showMore.value
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: Colors.blueAccent,
                          );
                        }),
                        alignment: PlaceholderAlignment.middle)
                  ])),
                )
              : Container(),
        ],
      ),
    );
  }
}
