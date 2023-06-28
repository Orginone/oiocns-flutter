

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/widget/gy_scaffold.dart';
import 'package:orginone/widget/unified.dart';

import 'base_breadcrumb_nav_controller.dart';
import 'base_get_breadcrumb_nav_state.dart';
import '../base_get_view.dart';

abstract class BaseBreadcrumbNavPage<T extends BaseBreadcrumbNavController,S extends BaseBreadcrumbNavState> extends BaseGetView<T,S>{

  TextStyle get _selectedTextStyle =>
  TextStyle(fontSize: 20.sp, color: XColors.themeColor);

  TextStyle get _unSelectedTextStyle =>
  TextStyle(fontSize: 20.sp, color: Colors.black);

  @override
  Widget buildView() {
    List<Widget> nextStep = [];
    if (state.bcNav.isNotEmpty) {
      for (var value in state.bcNav) {
        nextStep.add(_level(value));
      }
    }
    return GyScaffold(
      titleSpacing: 0,
      leading: BackButton(color: Colors.black,onPressed: (){
        controller.popAll();
      },),
      centerTitle: false,
      appBarColor: Colors.white,
      titleWidget:SingleChildScrollView(scrollDirection: Axis.horizontal,controller: state.navBarController,child: Row(children:nextStep,),),
      body: body(),
    );
  }


  Widget _level(BaseBreadcrumbNavInfo info) {
    int index = state.bcNav.indexOf(info);
    return GestureDetector(
      onTap: () {
        controller.pop(index);
      },
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
                text: " • ",
                style: _unSelectedTextStyle),
            TextSpan(
                text: info.title,
                style: index == state.bcNav.length - 1
                    ? _selectedTextStyle
                    : _unSelectedTextStyle),
          ],
        ),
      ),
    );
  }

  Widget body();
}