import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/widget/common_widget.dart';

import 'logic.dart';
import 'state.dart';

class AsstesDetailsPage
    extends BaseGetView<AsstesDetailsController, AsstesDetailsState> {
  EdgeInsetsGeometry get defaultPadding =>
      EdgeInsets.symmetric(vertical: 17.h, horizontal: 16.w);

  @override
  Widget buildView() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("资产详情"),
        elevation: 0,
        centerTitle: true,
        backgroundColor: XColors.themeColor,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey.shade200,width: 0.5))
                ),
                child: Container(
                    child: CommonWidget.commonHeadInfoWidget("测试1"),
                    padding: defaultPadding),
              ),
              CommonWidget.commonTextContentWidget("资产分类", "123",
                  textSize: 22, contentSize: 22, padding: defaultPadding),
              CommonWidget.commonTextContentWidget("资产编号", "",
                  textSize: 22, contentSize: 22, padding: defaultPadding),
              CommonWidget.commonTextContentWidget("资产名称", "",
                  textSize: 22, contentSize: 22, padding: defaultPadding),
              CommonWidget.commonTextContentWidget("品牌", "",
                  textSize: 22, contentSize: 22, padding: defaultPadding),
              CommonWidget.commonTextContentWidget("规格型号", "",
                  textSize: 22, contentSize: 22, padding: defaultPadding),
              CommonWidget.commonTextContentWidget("存放地点", "",
                  textSize: 22, contentSize: 22, padding: defaultPadding),
              CommonWidget.commonTextContentWidget("原值", "",
                  textSize: 22, contentSize: 22, padding: defaultPadding),
              CommonWidget.commonTextContentWidget("价值类型", "",
                  textSize: 22, contentSize: 22, padding: defaultPadding),
              CommonWidget.commonTextContentWidget("取得日期", "",
                  textSize: 22, contentSize: 22, padding: defaultPadding),
              CommonWidget.commonTextContentWidget("投入使用日期", "",
                  textSize: 22, contentSize: 22, padding: defaultPadding),
              CommonWidget.commonTextContentWidget("最低使用年限(月)", "",
                  textSize: 22, contentSize: 22, padding: defaultPadding),
              CommonWidget.commonTextContentWidget("取得方式", "",
                  textSize: 22, contentSize: 22, padding: defaultPadding),
              CommonWidget.commonTextContentWidget("发票号", "",
                  textSize: 22, contentSize: 22, padding: defaultPadding),
              CommonWidget.commonTextContentWidget("资金来源", "",
                  textSize: 22, contentSize: 22, padding: defaultPadding),
              CommonWidget.commonTextContentWidget("计量单位", "",
                  textSize: 22, contentSize: 22, padding: defaultPadding),
              CommonWidget.commonTextContentWidget("使用人", "",
                  textSize: 22, contentSize: 22, padding: defaultPadding),
              CommonWidget.commonTextContentWidget("使用部门", "",
                  textSize: 22, contentSize: 22, padding: defaultPadding),
              CommonWidget.commonTextContentWidget("生产厂家", "",
                  textSize: 22, contentSize: 22, padding: defaultPadding),
              CommonWidget.commonTextContentWidget("使用状况", "",
                  textSize: 22, contentSize: 22, padding: defaultPadding),
              CommonWidget.commonTextContentWidget("供应商", "",
                  textSize: 22, contentSize: 22, padding: defaultPadding),
              CommonWidget.commonTextContentWidget("数量", "",
                  textSize: 22, contentSize: 22, padding: defaultPadding),
              CommonWidget.commonTextContentWidget("备注", "",
                  textSize: 22, contentSize: 22, padding: defaultPadding),
              CommonWidget.commonTextContentWidget("保管人", "",
                  textSize: 22, contentSize: 22, padding: defaultPadding),
              CommonWidget.commonTextContentWidget("GS1编码", "",
                  textSize: 22, contentSize: 22, padding: defaultPadding),
              CommonWidget.commonTextContentWidget("是否信创", "",
                  textSize: 22, contentSize: 22, padding: defaultPadding),
              CommonWidget.commonTextContentWidget("实际使用人", "",
                  textSize: 22, contentSize: 22, padding: defaultPadding),
            ],
          ),
        ),
      ),
    );
  }
}