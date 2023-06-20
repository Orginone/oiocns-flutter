import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:logging/logging.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/thing/application.dart';
import 'package:orginone/pages/home/index/HorizontalScrollMenu/QuickEntry.dart';
import 'package:orginone/pages/home/index/news/searchBarWidget.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/widget/image_widget.dart';
import 'package:orginone/widget/unified.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

/// 设置首页
class IndexPage extends GetView<SettingController> {
  final Logger log = Logger("IndexPage");

  // 轮播图片
  List<String> imageList = [
    "images/bg_center1.png",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: XColors.white,
      drawerScrimColor: XColors.white,
      body: RefreshIndicator(
        onRefresh: () async{
          await controller.provider.loadApps(true);
        },
        child: ListView(
            scrollDirection: Axis.vertical,
            children: <Widget>[
              ImageWidget(imageList.first),
              Container(
                  decoration: BoxDecoration(
                      color: XColors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: SizedBox(
                    height: 12.h,
                  )),
              Container(
                color: XColors.white,
                child: SizedBox(
                  height: 12.h,
                ),
              ),
              Container(
                  decoration: BoxDecoration(
                      color: XColors.white,
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.fromLTRB(11.0, 0, 0, 0),
                  alignment: Alignment.topLeft,
                  child: Text(
                "常用",
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
              )),
          Container(
            color: XColors.white,
            child: SizedBox(
              height: 12.h,
            ),
          ),
          const MyHorizontalMenu(),
          Container(
              decoration: BoxDecoration(
                  color: XColors.white, borderRadius: BorderRadius.circular(10)),
              child: SizedBox(
                height: 12.h,
              )),
          Container(
            color: XColors.white,
            padding: EdgeInsets.only(left: 12.w, right: 12.w),
            child: ListView(
                  shrinkWrap: true,
              children: [
                Obx(() {
                  return CardChildWidget('应用', controller.provider.myApps.value);
                }),
              ],
            ),
          ),
        ]),
      ),
    );
  }


  /// Carousel 轮播图
  ///
  ///  @param List<String> imageList
  ///
  ///  @returns Widget
  Widget _carousel(List<String> imageList) {
    return GFCarousel(
      hasPagination: true,
      aspectRatio: 7 / 2,
      activeIndicator: GFColors.WHITE,
      autoPlay: true,
      items: imageList.map(
            (img) {
          return ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            child: Image.asset(img, fit: BoxFit.fill, width: 1000.0),
          );
        },
      ).toList(),
    );
  }
}


class CardChildWidget extends GetView<SettingController> {
  String itemName;

  List<IApplication> value;

  CardChildWidget(this.itemName, this.value);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: XColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            itemName,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 12.h,
          ),
          GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(top: 10.h, bottom: 20.h),
              shrinkWrap: true,
              itemCount: value.length,
              gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisExtent:110.h,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    var item = value[index];
                    late ITarget target;
                    for (var value1 in controller.user.targets) {
                      if(value1.belong.id == item.belongId){
                        target = value1;
                        continue;
                      }
                    }
                    // Get.toNamed(Routers.workStart, arguments: {"defines": item.defines,'target':target});
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: XColors.navigatorBgColor,
                        ),
                        alignment: Alignment.center,
                        width: 65.w,
                        height: 65.w,
                        child: ImageWidget(
                          value[index].metadata.avatarThumbnail(),
                          size: 64.w,
                          circular: true,
                        ),
                      ),
                      Text(
                        value[index].metadata.name!,
                        style: XFonts.size18Black6,maxLines: 1,overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }
}

// 数据检测 start
class TemperatureData {
  final String month;
  final double high;
  final double low;

  TemperatureData(this.month, this.high, this.low);
}

late List<_ChartData> data = [
  _ChartData('CHN', 12),
  _ChartData('GER', 15),
  _ChartData('RUS', 30),
  _ChartData('BRZ', 6.4),
  _ChartData('IND', 14)
];
late TooltipBehavior _tooltip = TooltipBehavior(enable: true);

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}

class pieChartSalesData {
  final String year;
  final double sales;

  pieChartSalesData(this.year, this.sales);
}
// 数据检测 end

class IndexPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SearchBarController());
  }
}
