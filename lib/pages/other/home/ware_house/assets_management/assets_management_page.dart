import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/pages/other/home/ware_house/assets_management/apply_list.dart';
import '../../../../../routers.dart';
import './classification_row.dart';

class AssetsManagementPage extends StatelessWidget {
  const AssetsManagementPage({Key? key}) : super(key: key);

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
          '资产管理',
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
            padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 0.h),
            child: SizedBox(
              height: 40.h,
              child: TextField(
                autofocus: false,
                style: TextStyle(fontSize: 20.sp),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color.fromARGB(255, 255, 255, 255),
                  contentPadding: const EdgeInsets.all(4),
                  hintText: "搜索",
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
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "应用",
                  style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color.fromARGB(255, 51, 52, 54)),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        child: Text(
                          "购买",
                          style: TextStyle(
                              fontSize: 17.sp,
                              color: const Color.fromARGB(255, 71, 90, 212)),
                        ),
                        onTap: () {
                          Get.toNamed(Routers.market);
                        }, //点击/长按
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      GestureDetector(
                        child: Text(
                          "创建",
                          style: TextStyle(
                              fontSize: 17.sp,
                              color: const Color.fromARGB(255, 71, 90, 212)),
                        ),
                        onTap: () => print("创建"), //点击/长按
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      GestureDetector(
                        child: Text(
                          "暂存",
                          style: TextStyle(
                              fontSize: 17.sp,
                              color: const Color.fromARGB(255, 71, 90, 212)),
                        ),
                        onTap: () => print("暂存"), //点击/长按
                      ),
                    ]),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 10.h),
            child: const ClassificationRow(),
          ),
          const ApplyList(),
        ],
      ),
    );
  }
}
