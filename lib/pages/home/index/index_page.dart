import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:logging/logging.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/thing/app/application.dart';
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
    "images/bg_center2.png",
    "images/bg_center3.png",
  ];

  @override
  Widget build(BuildContext context) {
    double x = 0, y = 0;
    return Scaffold(
      backgroundColor: XColors.white,
      drawerScrimColor: XColors.white,
      drawer: Drawer(
        width: MediaQuery.of(context).size.width,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: XColors.navigatorBgColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.file_download_done_outlined),
                        onPressed: () {
                          Navigator.pop(context); // 关闭Drawer
                        },
                      ),
                      const Text(
                        '今天还没打卡哦',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        width: 212.h,
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context); // 关闭Drawer
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 22.h,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 22.h,
                      ),
                      GFAvatar(
                          size: GFSize.LARGE,
                          backgroundImage: NetworkImage(
                              'https://s3.bmp.ovh/imgs/2023/02/28/3d1e012ec88ff534.jpg'),
                          shape: GFAvatarShape.circle),
                      SizedBox(
                        width: 42.h,
                      ),
                      Column(
                        children: [
                          Text(
                            '昵称：凌志强',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '等级：999级',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '个性签名：物有本末，事有始终。',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          )
                        ],
                      ),
                      IconButton(
                        icon: Icon(Icons.qr_code_scanner_outlined),
                        onPressed: () {
                          Get.toNamed(Routers.addFriend);
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('收藏'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.wallet),
              title: const Text('钱包'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.insert_drive_file_sharp),
              title: const Text('文件'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.source),
              title: const Text('资源'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            _carousel(imageList),
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
    );
  }

  Widget _popMenuItem(
    BuildContext context,
    IconData icon,
    String text,
    Function func,
  ) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.pop(context);
        func();
      },
      child: SizedBox(
        height: 40.h,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.black),
            Container(
              margin: EdgeInsets.only(left: 20.w),
            ),
            Text(text),
          ],
        ),
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
          return Container(
            margin: const EdgeInsets.only(left: 8.0),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              child: Image.asset(img, fit: BoxFit.fill, width: 1000.0),
            ),
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
                mainAxisExtent:100.h,
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
                    Get.toNamed(Routers.workStart, arguments: {"defines": item.defines,'target':target});
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          color: XColors.navigatorBgColor,
                        ),
                        alignment: Alignment.center,
                        width: 70.w,
                        height: 70.w,
                        child: ImageWidget(
                          value[index].share.avatar?.thumbnailUint8List,
                          size: 64.w,
                          circular: true,
                        ),
                      ),
                      Text(
                        value[index].metadata.name,
                        style: XFonts.size18Black6,
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
