import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/component/a_font.dart';
import 'package:orginone/component/text_search.dart';

class ApplicationPage extends GetView<ApplicationController> {
  const ApplicationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 25.w, right: 25.w),
      child: Column(
        children: [
          TextSearch(
            margin: EdgeInsets.only(top: 20.h),
            searchingCallback: controller.searchingCallback,
          ),
          Padding(padding: EdgeInsets.only(top: 10.h)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("最近打开", style: AFont.instance.size20Black3W700),
              Text("管理应用 > ", style: AFont.instance.size14Black3)
            ],
          ),
        ],
      ),
    );
  }

  _recent() {
    return GridView.count(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      crossAxisCount: 5,
      childAspectRatio: 80 / 100,
      children: [
      ],
    );
  }

  _recentItem(){
    return Container(
      width: 64.w,
      height: 64.w,

    );
  }
}

class ApplicationController extends GetxController {
  searchingCallback(String value) {}
}

class ApplicationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ApplicationController());
  }
}
