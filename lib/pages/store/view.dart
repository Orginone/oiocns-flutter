import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/unified.dart';
import 'package:orginone/config/color.dart';
import 'package:orginone/dart/core/getx/base_get_page_view.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/widget/gy_scaffold.dart';

import 'item.dart';
import 'logic.dart';
import 'state.dart';
class StorePage
    extends BaseGetPageView<StoreController, StoreState> {
  @override
  Widget buildView() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          CommonWidget.commonSearchBarWidget(hint: "请输入内容",searchColor: Colors.grey.shade200),
          Expanded(
            child: ListView.builder(itemBuilder:(context,index){
              if(index == 0){
                return content();
              }
              return StoreItem();
            },itemCount: 11,),
          )
        ],
      ),
    );
  }


  Widget content(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("共10项内容",style: XFonts.size18Black9,),
          DropdownButton( items: const [
            DropdownMenuItem(
              value: 'time',
              child: Text('存储时间'),
            )
          ], onChanged: (String? value) {

          },value: "time",underline: const SizedBox(),),
        ],
      ),
    );
  }


  @override
  StoreController getController() {
    return StoreController();
  }


  @override
  String tag() {
    // TODO: implement tag
    return "WareHouse";
  }
}
