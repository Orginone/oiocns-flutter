import 'package:flutter/material.dart';
import 'package:orginone/dart/core/getx/base_bindings.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:orginone/dart/core/getx/base_get_page_view.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/gy_scaffold.dart';

class CompanyInfoPage
    extends BaseGetPageView<CompanyInfoController, CompanyInfoState> {
  @override
  Widget buildView() {
    return GyScaffold(
        titleName: "关系",
        titleStyle: TextStyle(color: Colors.white),
        // appBarColor: Colors.white,
        // backColor: Colors.black54,
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                child: body(),
              )
            ],
          ),
        ));
  }

  Widget body() {
    return Column(
      children: [
        CommonWidget.commonBreadcrumbNavWidget(
            firstTitle: "关系", allTitle: List.empty()),
        SizedBox(height: 16.0),
        Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [
              Text("单位名称"),
              Text("杭州共裕数字技术有限公司", style: TextStyle(color: Colors.black45))
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [
              Text("社会统一信用代码"),
              Text(
                "12345667908",
                style: TextStyle(
                  color: Colors.black45,
                ),
              )
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [
              Text("团队简称"),
              Text(
                "共裕",
                style: TextStyle(
                  color: Colors.black45,
                ),
              )
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [
              Text("团队代号"),
              Text(
                "共裕",
                style: TextStyle(
                  color: Colors.black45,
                ),
              )
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [
              Text("单位简介"),
              Text(
                "无",
                style: TextStyle(
                  color: Colors.black45,
                ),
              )
            ])
          ],
        ),
      ],
    );
  }

  @override
  CompanyInfoController getController() {
    return CompanyInfoController();
  }
}

class CompanyInfoBingding extends BaseBindings<CompanyInfoController> {
  @override
  CompanyInfoController getController() {
    return CompanyInfoController();
  }
}

class CompanyInfoController extends BaseController<CompanyInfoState> {}

class CompanyInfoState extends BaseGetState {}
