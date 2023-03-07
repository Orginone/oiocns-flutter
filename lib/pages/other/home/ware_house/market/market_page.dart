import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import './market_apply_list.dart';

class MarketPage extends StatelessWidget {
  const MarketPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 244, 248),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 24.sp,
            color: const Color.fromARGB(255, 116, 117, 122),
          ),
          tooltip: "返回",
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(Icons.more_horiz,
                  size: 28.sp, color: const Color.fromARGB(255, 116, 117, 122)))
        ],
        title: Text(
          '杭商城',
          style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 242, 244, 248),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 20.h),
            child: SizedBox(
              height: 40.h,
              child: TextField(
                autofocus: false,
                style: TextStyle(fontSize: 20.sp),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color.fromARGB(255, 255, 255, 255),
                  contentPadding: const EdgeInsets.all(4),
                  hintText: "选择分类",
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
          const MarketApplyList()
        ],
      ),
    );
  }
}
