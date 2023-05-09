import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_item.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_multiplex_page.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_get_breadcrumb_nav_state.dart';
import 'package:orginone/widget/common_widget.dart';
import 'logic.dart';
import 'state.dart';

class WareHouseManagementPage extends BaseBreadcrumbNavMultiplexPage<WareHouseManagementController,WareHouseManagementState>{


  @override
  Widget body() {
   return SingleChildScrollView(
     child: Padding(
       padding: EdgeInsets.symmetric(vertical: 15.h),
       child: Column(
         children: wareHouseData(),
       ),
     ),
   );
  }


  List<Widget> wareHouseData() {
    List<Widget> children = [];
    for (var child in state.model.value!.children) {
      children.add(Column(
        children: [
          CommonWidget.commonHeadInfoWidget(child.name),
          ...child.children.map((e) {
            return BaseBreadcrumbNavItem<WareHouseBreadcrumbNav>(
              item: e,
              onTap: () {

              },
              onNext: (){
              },

            );
          }).toList(),
        ],
      ));
    }
    return children;
  }

  @override
  WareHouseManagementController getController() {
    return WareHouseManagementController();
  }

}