import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/widget/gy_scaffold.dart';
import 'item.dart';
import 'logic.dart';
import 'state.dart';

class ApplicationPage
    extends BaseGetView<ApplicationController, ApplicationState> {
  @override
  Widget buildView() {
    return GyScaffold(
      titleName: "应用",
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          application(),
          tabBar(),
          Expanded(
            child: TabBarView(
                controller: state.tabController,
                children: tabTitle.map((e) {
                  return listView(e);
                }).toList()),
          )
        ],
      ),
    );
  }

  Widget listView(String status) {

    return Obx(() {
      int count = 0;
      var products = [];
      if (status == "全部") {
        products = state.products;
        count = products.length;
      } else {
        var list;
        if(status == "共享的"){
          list = state.products.where((p0) => p0.prod.belongId != controller.settingCtrl.space.id);
        }else{
          list = state.products.where((p0) => p0.prod.source == status && p0.prod.belongId == controller.settingCtrl.space.id);
        }
        if (list.isNotEmpty) {
          products = list.toList();
        }
        count = products.length;
      }
      return ListView.builder(
        itemBuilder: (context, index) {
          return Item(product: products[index],);
        },
        itemCount: count,
      );
    });
  }

  Widget application() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "应用",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            "购买",
            style: TextStyle(color: Colors.blue, fontSize: 16.sp),
          ),
          SizedBox(
            width: 10.w,
          ),
          Text(
            "创建",
            style: TextStyle(color: Colors.blue, fontSize: 16.sp),
          ),
          // SizedBox(
          //   width: 10.w,
          // ),
          // Text(
          //   "暂存",
          //   style: TextStyle(color: Colors.blue, fontSize: 16.sp),
          // )
        ],
      ),
    );
  }

  Widget tabBar() {
    return Container(
      color: Colors.grey.shade100,
      alignment: Alignment.centerLeft,
      child: TabBar(
        controller: state.tabController,
        tabs: tabTitle.map((e) {
          return Tab(
            text: e,
            height: 40.h,
          );
        }).toList(),
        indicatorColor: XColors.themeColor,
        indicatorSize: TabBarIndicatorSize.label,
        unselectedLabelColor: Colors.grey,
        unselectedLabelStyle: TextStyle(fontSize: 16.sp),
        labelColor: Colors.black,
        labelStyle: TextStyle(fontSize: 16.sp),
        isScrollable: true,
      ),
    );
  }
}
