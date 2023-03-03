import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/util/date_utils.dart';
import 'package:orginone/widget/common_widget.dart';

import 'logic.dart';
import 'state.dart';

class AssetsDetailsPage
    extends BaseGetView<AssetsDetailsController, AssetsDetailsState> {
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
                    child: CommonWidget.commonHeadInfoWidget(state.assets.assetName??""),
                    padding: defaultPadding),
              ),
              CommonWidget.commonTextContentWidget("资产分类", state.assets.assetType??"",
                  textSize: 22, contentSize: 22, padding: defaultPadding),
              CommonWidget.commonTextContentWidget("资产编号", state.assets.assetCode??"",
                  textSize: 22, contentSize: 22, padding: defaultPadding),
              CommonWidget.commonTextContentWidget("资产名称", state.assets.assetName??"",
                  textSize: 22, contentSize: 22, padding: defaultPadding),
              CommonWidget.commonTextContentWidget("品牌", state.assets.brand??"",
                  textSize: 22, contentSize: 22, padding: defaultPadding),
              CommonWidget.commonTextContentWidget("规格型号", state.assets.specMod??"",
                  textSize: 22, contentSize: 22, padding: defaultPadding),
              CommonWidget.commonTextContentWidget("存放地点", state.assets.location??"",
                  textSize: 22, contentSize: 22, padding: defaultPadding),
              CommonWidget.commonTextContentWidget("原值", "${state.assets.netVal??0}",
                  textSize: 22, contentSize: 22, padding: defaultPadding),
              CommonWidget.commonTextContentWidget("价值类型", "原值",
                  textSize: 22, contentSize: 22, padding: defaultPadding),
              CommonWidget.commonTextContentWidget("取得日期", DateTime.tryParse(state.assets.quderq??"")?.format()??"",
                  textSize: 22, contentSize: 22, padding: defaultPadding),
              CommonWidget.commonTextContentWidget("投入使用日期", DateTime.tryParse(state.assets.startDate??"")?.format()??"",
                  textSize: 22, contentSize: 22, padding: defaultPadding),
              CommonWidget.commonTextContentWidget("最低使用年限(月)", state.assets.minimumLimit??"",
                  textSize: 22, contentSize: 22, padding: defaultPadding),
              CommonWidget.commonTextContentWidget("取得方式", "",
                  textSize: 22, contentSize: 22, padding: defaultPadding),
              CommonWidget.commonTextContentWidget("发票号", state.assets.invoiceNo??"",
                  textSize: 22, contentSize: 22, padding: defaultPadding),
              CommonWidget.commonTextContentWidget("资金来源", state.assets.sourcesOfFunding??"",
                  textSize: 22, contentSize: 22, padding: defaultPadding),
              CommonWidget.commonTextContentWidget("计量单位", state.assets.numUnit??"",
                  textSize: 22, contentSize: 22, padding: defaultPadding),
              CommonWidget.commonTextContentWidget("使用人", state.assets.userName??"",
                  textSize: 22, contentSize: 22, padding: defaultPadding),
              CommonWidget.commonTextContentWidget("使用部门", state.assets.useDeptName??"",
                  textSize: 22, contentSize: 22, padding: defaultPadding),
              CommonWidget.commonTextContentWidget("生产厂家", state.assets.manufacturer??"",
                  textSize: 22, contentSize: 22, padding: defaultPadding),
              CommonWidget.commonTextContentWidget("使用状况", "",
                  textSize: 22, contentSize: 22, padding: defaultPadding),
              CommonWidget.commonTextContentWidget("供应商", state.assets.supplier??"",
                  textSize: 22, contentSize: 22, padding: defaultPadding),
              CommonWidget.commonTextContentWidget("数量", "${state.assets.numOrArea??0}",
                  textSize: 22, contentSize: 22, padding: defaultPadding),
              CommonWidget.commonTextContentWidget("备注", state.assets.remark??"",
                  textSize: 22, contentSize: 22, padding: defaultPadding),
              CommonWidget.commonTextContentWidget("保管人", state.assets.theDepository?['value']??"",
                  textSize: 22, contentSize: 22, padding: defaultPadding),
              CommonWidget.commonTextContentWidget("GS1编码", state.assets.gs1??"",
                  textSize: 22, contentSize: 22, padding: defaultPadding),
              CommonWidget.commonTextContentWidget("是否信创", state.assets.isDistribution==null?"":state.assets.isDistribution!?"是":"否",
                  textSize: 22, contentSize: 22, padding: defaultPadding),
              CommonWidget.commonTextContentWidget("实际使用人", state.assets.userName??"",
                  textSize: 22, contentSize: 22, padding: defaultPadding),
            ],
          ),
        ),
      ),
    );
  }
}