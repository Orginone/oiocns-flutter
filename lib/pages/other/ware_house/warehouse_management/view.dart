import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_item.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_multiplex_page.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_get_breadcrumb_nav_state.dart';
import 'package:orginone/widget/common_widget.dart';
import 'logic.dart';
import 'state.dart';

class WarehouseManagementPage extends BaseBreadcrumbNavMultiplexPage<WarehouseManagementController,WarehouseManagementState>{


  @override
  Widget body() {
   return SingleChildScrollView(
     child: Padding(
       padding: EdgeInsets.symmetric(vertical: 15.h),
       child: Column(
         children: [
           CommonWidget.commonHeadInfoWidget("个人"),
           ...personalWork.map((e) {
             return BaseBreadcrumbNavItem(item: BaseBreadcrumbNavModel(name: e, children: []),onTap: (){
               controller.jumpUniversalNavigator(e);
             },);
           }).toList(),
           CommonWidget.commonHeadInfoWidget("组织"),
           ...state.spaces.map((e){
             return BaseBreadcrumbNavItem(item: BaseBreadcrumbNavModel(name: e.name, children: []),onTap: (){
               controller.jumpUniversalNavigator(e.name);
             },);
           }),
         ],
       ),
     ),
   );
  }

  @override
  WarehouseManagementController getController() {
    return WarehouseManagementController();
  }

}