import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/component/a_font.dart';
import 'package:orginone/component/text_search.dart';
import 'package:orginone/component/unified_colors.dart';
import 'package:orginone/page/home/application/applicatino_controller.dart';
import 'package:orginone/routers.dart';

class ApplicationPage extends GetView<ApplicationController> {
  const ApplicationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 25.w, right: 25.w),
      color: UnifiedColors.navigatorBgColor,
      child: Column(
        children: [
          TextSearch(
            margin: EdgeInsets.only(top: 20.h),
            searchingCallback: controller.searchingCallback,
            bgColor: Colors.white,
          ),
          Padding(padding: EdgeInsets.only(top: 24.h)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("最近打开", style: AFont.instance.size20Black3W700),
              Wrap(
                children: [
                  GestureDetector(
                    onTap: () => Get.toNamed(Routers.market),
                    child: Text(
                      "前往商店",
                      style: AFont.instance.size14themeColorW500,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(left: 10.w)),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(Routers.manager);
                    },
                    child: Text("管理应用 > ", style: AFont.instance.size14Black3),
                  ),
                ],
              )
            ],
          ),
          Padding(padding: EdgeInsets.only(top: 12.h)),
          _recent(),
          Padding(padding: EdgeInsets.only(top: 24.h)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("常用分类", style: AFont.instance.size20Black3W700),
              Wrap(children: [
                Padding(padding: EdgeInsets.only(left: 10.w)),
                Text("新建分类", style: AFont.instance.size14themeColorW500),
                Padding(padding: EdgeInsets.only(left: 10.w)),
                Text("更多分类", style: AFont.instance.size14themeColorW500),
              ])
            ],
          ),
          Padding(padding: EdgeInsets.only(top: 12.h)),
          _applications()
        ],
      ),
    );
  }

  Widget _recent() {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5.w)),
      ),
      child: GridView.count(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        crossAxisCount: 5,
        childAspectRatio: 80 / 100,
        children: [
          _recentItem("资产应用"),
          _recentItem("资产应用"),
          _recentItem("资产应用"),
          _recentItem("资产应用"),
          _recentItem("资产应用"),
        ],
      ),
    );
  }

  Widget _recentItem(String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 64.w,
          height: 64.w,
          decoration: BoxDecoration(
            color: UnifiedColors.themeColor,
            borderRadius: BorderRadius.all(Radius.circular(20.w)),
          ),
          child: const Icon(Icons.recent_actors, color: Colors.white),
        ),
        Padding(padding: EdgeInsets.only(top: 10.h)),
        Text(label, style: AFont.instance.size12Black3)
      ],
    );
  }

  Widget _applications() {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5.w)),
      ),
      child: GridView.count(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        crossAxisCount: 5,
        childAspectRatio: 80 / 100,
        children: [
          _applicationItem("首页"),
          _applicationItem("消息"),
          _applicationItem("我的应用"),
          _applicationItem("应用商店"),
          _applicationItem("资产应用"),
          _applicationItem("首页"),
          _applicationItem("消息"),
          _applicationItem("我的应用"),
          _applicationItem("应用商店"),
          _applicationItem("资产应用"),
        ],
      ),
    );
  }

  Widget _applicationItem(String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 64.w,
          height: 64.w,
          decoration: BoxDecoration(
            color: UnifiedColors.themeColor,
            borderRadius: BorderRadius.all(Radius.circular(5.w)),
          ),
          child: const Icon(Icons.storefront, color: Colors.white),
        ),
        Padding(padding: EdgeInsets.only(top: 10.h)),
        Text(label, style: AFont.instance.size12Black3)
      ],
    );
  }
}

class ApplicationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ApplicationController());
  }
}
