import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/widget/gy_scaffold.dart';
import 'package:orginone/widget/start_rating_widget.dart';

import 'logic.dart';
import 'state.dart';

class ApplicationPage
    extends BaseGetView<ApplicationController, ApplicationState> {
  @override
  Widget buildView() {
    return GyScaffold(
      titleName: "应用",
      body: Column(
        children: [
          application(),
          tabBar(),
          Expanded(
            child: TabBarView(
              controller: state.tabController,
              children: [
                ListView.builder(
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.w),
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: 10.h, horizontal: 10.w),
                      margin:
                          EdgeInsets.only(top: 10.h, right: 16.w, left: 16.w),
                      child: Row(
                        children: [
                          Container(
                            width: 56.w,
                            height: 56.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.w),
                                image: const DecorationImage(
                                    image: NetworkImage(
                                        "http://anyinone.com:888/img/logo/logo3.jpg"))),
                          ),
                          SizedBox(width: 20.w,),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("资产内控",style: TextStyle(color: Colors.black,fontSize: 16.sp),),
                                Text("应用描述:",style: TextStyle(color: Colors.grey.shade400,fontSize: 14.sp),),
                                StartRatingWidget(rating: 9.5,size: 20.w,style: TextStyle(fontSize: 14.sp),),
                              ],
                            ),
                          ),
                          SizedBox(width: 20.w,),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blueAccent,width: 1),
                              borderRadius: BorderRadius.circular(16.w),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 2.h,horizontal: 15.w),
                            child: Text("更多",style: TextStyle(color: Colors.blueAccent,fontSize: 16.sp),),
                          )
                        ],
                      ),
                    );
                  },
                  itemCount: 1,
                )
              ],
            ),
          )
        ],
      ),
    );
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
          SizedBox(
            width: 10.w,
          ),
          Text(
            "暂存",
            style: TextStyle(color: Colors.blue, fontSize: 16.sp),
          )
        ],
      ),
    );
  }

  Widget tabBar() {
    return Container(
      color: Colors.grey.shade200,
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
