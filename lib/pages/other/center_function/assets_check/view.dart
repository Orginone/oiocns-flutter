import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/pages/other/assets_config.dart';
import 'package:orginone/widget/keep_alive_widget.dart';

import 'check/state.dart';
import 'check/view.dart';
import 'logic.dart';
import 'state.dart';



class AssetsCheckPage extends BaseGetView<AssetsCheckController,AssetsCheckState>{
  @override
  Widget buildView() {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text("资产盘点"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: XColors.themeColor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: XColors.themeColor,
              child: tabBar(),
            ),
            Expanded(
              child: TabBarView(
                controller: state.tabController,
                children: [
                  KeepAliveWidget(child: CheckPage(CheckType.notStarted)),
                  KeepAliveWidget(child: CheckPage(CheckType.saved)),
                  KeepAliveWidget(child: CheckPage(CheckType.loss)),
                ],
              ),
            ),
            bottomButton(),
          ],
        ),
      ),
    );
  }

  Widget tabBar() {
    return Container(
      color: XColors.themeColor,
      child: Column(
        children: [
          TabBar(
              controller: state.tabController,
              padding: const EdgeInsets.symmetric(vertical: 10),
              tabs: AssetsCheckTabTitle
                  .map((e) => Tab(
                text: e,
              ))
                  .toList(),
              indicatorColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.label,
              unselectedLabelStyle:
              TextStyle(fontSize: 21.sp, color: Colors.grey),
              labelStyle: TextStyle(fontSize: 21.sp, color: Colors.white)),
        ],
      ),
    );
  }

  Widget bottomButton(){
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 15.h),
      color: Colors.white,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: (){
              controller.allInventory();
            },
            child: Container(
              width: 300.w,
              height: 50.h,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.w),
                  border: Border.all(color: XColors.themeColor)
              ),
              alignment: Alignment.center,
              child: Text(
                "完成盘点",
                style: TextStyle(color: XColors.themeColor, fontSize: 16.sp),
              ),
            ),
          ),
          SizedBox(width: 20.w,),
          GestureDetector(
            onTap: (){

            },
            child: Container(
              width: 150.w,
              height: 50.h,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(4.w),
              ),
              alignment: Alignment.center,
              child: Text(
                "扫一扫",
                style: TextStyle(color: Colors.white, fontSize: 16.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }

}