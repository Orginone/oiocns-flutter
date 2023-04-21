import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_item.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_multiplex_page.dart';
import 'package:orginone/widget/common_widget.dart';

import 'logic.dart';
import 'state.dart';

class InitiateWorkPage
    extends BaseBreadcrumbNavMultiplexPage<InitiateWorkController, InitiateWorkState> {
  @override
  Widget body() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.h),
        child: Column(
          children: state.work.keys.map((key){
            return Column(
              children:[
                CommonWidget.commonHeadInfoWidget(key),
                ...state.work[key]!.map((e) {
                  return BaseBreadcrumbNavItem(item: e,onTap: (){
                    controller.jumpNext(e);
                  },);
                }).toList(),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  InitiateWorkController getController() {
   return InitiateWorkController();
  }

  @override
  String tag() {
    // TODO: implement tag
    return hashCode.toString();
  }
}