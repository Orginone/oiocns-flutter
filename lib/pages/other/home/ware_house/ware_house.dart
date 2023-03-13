import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../routers.dart';
import '../ware_house/recently_opened_page.dart';
import 'often_use_page.dart';

class WareHouse extends StatelessWidget {
  const WareHouse({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 252, 253, 255),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_horiz, color: Colors.black))
        ],
        title: Text(
          '仓库',
          style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 252, 253, 255),
      ),
      body: Column(
        children: [
          // input框
          Padding(
            padding: EdgeInsets.fromLTRB(26.w, 10.h, 26.w, 0.h),
            child: SizedBox(
              height: 50.h,
              child: TextField(
                autofocus: false,
                style: TextStyle(fontSize: 20.sp),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color.fromARGB(255, 242, 244, 248),
                  contentPadding: const EdgeInsets.all(4),
                  hintText: "通过手机号/邮箱搜索添加",
                  hintStyle: const TextStyle(
                      color: Color.fromARGB(255, 155, 156, 159)),
                  isDense: true,
                  prefixIcon: Icon(
                    Icons.search,
                    size: 24.sp,
                  ),
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10.0.w)),
                ),
                onChanged: (value) {
                  print(value);
                },
              ),
            ),
          ),
          // 最近打开
          Padding(
            padding: EdgeInsets.fromLTRB(22.w, 14.h, 26.w, 18.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "最近打开",
                  style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromARGB(255, 51, 52, 54)),
                ),
                GestureDetector(
                  child: Text.rich(TextSpan(children: [
                    TextSpan(text: "管理应用", style: TextStyle(fontSize: 17.sp)),
                    WidgetSpan(
                        child: Icon(
                          Icons.keyboard_arrow_right,
                          size: 17.sp,
                          color: const Color.fromARGB(255, 110, 111, 112),
                        ),
                        alignment: PlaceholderAlignment.middle)
                  ])),
                  onTap: () => Get.toNamed(Routers.assetsManagement), //点击/长按
                ),
              ],
            ),
          ),
          // 最近打开滑动页
          const RecentlyOpenedPage(),
          // 分隔线
          Container(
            height: 1,
            margin: EdgeInsets.symmetric(horizontal: 22.w),
            decoration:
                const BoxDecoration(color: Color.fromARGB(255, 211, 211, 211)),
          ),
          // 常用分类
          Padding(
            padding: EdgeInsets.fromLTRB(22.w, 14.h, 30.w, 0.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "常用分类",
                  style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromARGB(255, 51, 52, 54)),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        child: Text(
                          "新建分类",
                          style: TextStyle(fontSize: 17.sp),
                        ),
                        onTap: () => print("新建分类"), //点击/长按
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      GestureDetector(
                        child: Text(
                          "更多分类",
                          style: TextStyle(fontSize: 17.sp),
                        ),
                        onTap: () => print("更多分类"), //点击/长按
                      ),
                    ]),
              ],
            ),
          ),
          // 常用分类列表页
          SizedBox(
            width: double.infinity,
            height: 540.h,
            child: const OftenUsePage(),
          )
        ],
      ),
    );
  }
}
