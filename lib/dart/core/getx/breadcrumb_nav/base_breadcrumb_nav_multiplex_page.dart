

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/dart/core/getx/base_get_page_view.dart';
import 'package:orginone/widget/gy_scaffold.dart';
import 'package:orginone/widget/unified.dart';

import 'base_breadcrumb_nav_controller.dart';
import 'base_get_breadcrumb_nav_state.dart';

abstract class BaseBreadcrumbNavMultiplexPage<T extends BaseBreadcrumbNavController,S extends BaseBreadcrumbNavState> extends BaseGetPageView<T,S>{



  TextStyle get _selectedTextStyle =>
  TextStyle(fontSize: 20.sp, color: XColors.themeColor);

  TextStyle get _unSelectedTextStyle =>
  TextStyle(fontSize: 20.sp, color: Colors.black);

  @override
  Widget buildView() {

    return GyScaffold(
      leadingWidth: 0,
      leading: const SizedBox(),
      centerTitle: false,
      titleWidget: Container(
        color: Colors.white,
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 20),
        child: LayoutBuilder(builder: (context, type) {
          List<Widget> nextStep = [];
          if (state.bcNav.isNotEmpty) {
            for (var value in state.bcNav) {
              nextStep.add(_level(value));
            }
          }
          return Row(
            children: [
              IconButton(onPressed: (){
                controller.popAll();
              }, icon: const Icon(Icons.arrow_back_ios,color: Colors.black,),constraints: BoxConstraints(maxWidth: 40.w),),
              Expanded(
                child: SingleChildScrollView(scrollDirection: Axis.horizontal,child: Row(children:nextStep,),),
              )
            ],
          );
        }),
      ),
      body: body(),
    );
  }


  Widget _level(BaseBreadcrumbNavInfo info) {
    int index = state.bcNav.indexOf(info);
    List<InlineSpan> children = [
      TextSpan(
          text: info.title,
          style: index == state.bcNav.length - 1
              ? _selectedTextStyle
              : _unSelectedTextStyle),
    ];
    if ((index+1) != state.bcNav.length) {
      children.add(TextSpan(text: " • ", style: _unSelectedTextStyle));
    }
    return GestureDetector(
      onTap: () {
        controller.pop(index);
      },
      child: Text.rich(
        TextSpan(
          children: children,
        ),
      ),
    );
  }

  Widget body();

  @override
  String tag() {
    // TODO: implement tag
    return hashCode.toString();
  }
}