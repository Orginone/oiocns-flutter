import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/pages/other/home/ware_house/oiocns_components/star_score.dart';
import './assets_management_controller.dart';

class ApplyList extends StatelessWidget {
  const ApplyList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AssetsManagementController controller =
        Get.put(AssetsManagementController());
    return Container(
        height: 800.h,
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        child: Obx(() {
          return ListView.builder(
            itemCount: controller.applyList.length,
            itemBuilder: (BuildContext context, int index) {
              return ApplyCard(applyIteam: controller.applyList[index]);
            },
          );
        }));
  }
}

class ApplyCard extends StatelessWidget {
  final ApplyIteam applyIteam;
  const ApplyCard({Key? key, required this.applyIteam}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 16.h),
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.all(Radius.circular(6.w))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 60.0.w,
            height: 60.0.w,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.w)),
                color: Colors.black,
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(applyIteam.imageUrl))),
          ),
          messagePart(),
          GestureDetector(
            child: Container(
              padding: EdgeInsets.fromLTRB(10.w, 2.h, 10.w, 2.h),
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 1.w,
                      color: const Color.fromARGB(255, 27, 47, 203)),
                  borderRadius: BorderRadius.all(Radius.circular(12.w))),
              child: Text(
                "更多",
                style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color.fromARGB(255, 27, 47, 203)),
              ),
            ),
            onTap: () {
              // get.to
            },
          )
        ],
      ),
    );
  }

  Widget messagePart() {
    return SizedBox(
      width: 320.w,
      height: 60.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            applyIteam.name,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
          ),
          Text(
            applyIteam.message,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w100,
                color: const Color.fromARGB(255, 188, 189, 194)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              StarScore(score: applyIteam.score),
              SizedBox(
                width: 20.w,
              ),
              Icon(
                Icons.cloud_download_outlined,
                color: const Color.fromARGB(255, 188, 189, 194),
                size: 16.sp,
              ),
              SizedBox(
                width: 4.w,
              ),
              Text(
                "${applyIteam.downloadNum}",
                style: TextStyle(
                    fontSize: 12.sp,
                    // fontWeight: FontWeight.w100,
                    color: const Color.fromARGB(255, 188, 189, 194)),
              )
            ],
          )
        ],
      ),
    );
  }
}