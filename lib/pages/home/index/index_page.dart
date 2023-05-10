import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:logging/logging.dart';
import 'package:orginone/pages/home/index/HorizontalScrollMenu/MyMenuItem.dart';
import 'package:orginone/pages/home/index/news/searchBarWidget.dart';
import 'package:orginone/widget/template/base_view.dart';
import 'package:orginone/widget/unified.dart';
import 'package:orginone/config/enum.dart';
import 'package:orginone/config/forms.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/routers.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

/// 设置首页
@immutable
class IndexPage extends BaseView<IndexPageController> {
  final Logger log = Logger("IndexPage");

  // 轮播图片
  List<String> imageList = [
    "images/bg_center1.png",
    "images/bg_center2.png",
    "images/bg_center1.png",
    "images/bg_center2.png",
  ];

  LinkedHashMap map = LinkedHashMap();

  @override
  bool isUseScaffold() {
    return false;
  }

  @override
  LoadStatusX initStatus() {
    return LoadStatusX.success;
  }

// TODO 常用应用，超过五个字屏幕会越界
  IndexPage({Key? key}) : super(key: key) {
    map["常用应用"] = [
      {
        "id": 0,
        "icon": "icon",
        "cardName": "资产应用一",
        "func": () {
          Get.toNamed(Routers.addFriend);
          print('Go to home page');
        }
      },
      {"id": 1, "icon": "icon", "cardName": "资产应用2"},
      {"id": 2, "icon": "icon", "cardName": "资产应用3"},
      {"id": 4, "icon": "icon", "cardName": "资产应用4"},
      {"id": 5, "icon": "icon", "cardName": "资产应用5"},
      {"id": 6, "icon": "icon", "cardName": "资产应用6"},
      {
        "id": 7,
        "icon": "icon",
        "cardName": "资产应用7",
        "func": () async {
          // Get.toNamed(Routers.version);
        },
      },
      {"id": 8, "icon": "icon", "cardName": "资产应用8"},
      {"id": 9, "icon": "icon", "cardName": "资产应用9"},
      {"id": 10, "icon": "icon", "cardName": "资产应用10"},
    ];
  }

  @override
  Widget builder(BuildContext context) {
    double x = 0, y = 0;
    return Scaffold(
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
                          // Navigator.pop(context); // 关闭Drawer
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
          // shrinkWrap: true,
          // padding: const EdgeInsets.all(20.0),
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
                decoration: BoxDecoration(
                    color: XColors.white,
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.fromLTRB(11.0, 0, 0, 0),
                alignment: Alignment.topLeft,
                child: const Text("快捷入口")),
            // HorizontalMenu(),
            // MyHorizontalMenu(),
            MyHorizontalMenu(),
            Container(
                decoration: BoxDecoration(
                    color: XColors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: SizedBox(
                  height: 12.h,
                )),
            Container(
              color: XColors.bgColor,
              padding: EdgeInsets.only(left: 12.w, right: 12.w),
              child: ListView(
                shrinkWrap: true,
                children: _getItems()..add(Container(
                    // margin:
                    //     EdgeInsets.only(left: 20.w, bottom: 10.h, right: 20.w),
                    )),
              ),
            ),
            _dataMonitoring,
          ]),
    );
  }

  List<PopupMenuEntry> _popupMenus(BuildContext context) {
    return [
      PopupMenuItem(
        child: _popMenuItem(
          context,
          Icons.chat,
          "沟通",
          () async {
            Get.toNamed(Routers.mineUnit);
          },
        ),
      ),
      PopupMenuItem(
        child: _popMenuItem(
          context,
          Icons.calendar_month_outlined,
          "办事",
          () {
            // Get.toNamed(
            //   Routers.form,
            //   arguments: CreateCohort((value) {
            //     if (Get.isRegistered<SettingController>()) {
            //       Get.find<SettingController>()
            //           .user
            //           ?.create(TargetModel.fromJson(value))
            //           .then((value) => Get.back());
            //     }
            //   }),
            // );
          },
        ),
      ),
      PopupMenuItem(
        child: _popMenuItem(
          context,
          Icons.cabin,
          "仓库",
          () {

          },
        ),
      ),
      PopupMenuItem(
        child: _popMenuItem(
          context,
          Icons.person_pin,
          "设置",
          () {

          },
        ),
      ),
    ];
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

  List<Widget> _getItems() {
    List<Widget> children = [];
    debugPrint("--->size:${map.length}");
    map.forEach((key, value) {
      children.add(CardChildWidget(key, value));
    });
    return children;
  }

  /// Carousel 轮播图
  ///
  ///  @param List<String> imageList
  ///
  ///  @returns Widget
  Widget _carousel(List<String> imageList) {
    return GFCarousel(
      //是否显示圆点
      hasPagination: true,
      // 宽高比，跑马灯郑哥区域的宽高比。设置高度后这个参数无效。默认16/9
      aspectRatio: 7 / 2,
      //选中的圆点颜色
      activeIndicator: GFColors.WHITE,
      // 自动播放
      autoPlay: true,
      items: imageList.map(
        (img) {
          return Container(
            // margin: EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              child: Image.asset(img, fit: BoxFit.fill, width: 1000.0),
            ),
          );
        },
      ).toList(),
      // TODO 点击按钮跳转
      // onPageChanged: (index) {
      //   setState(() {
      //     index;
      //   });
      // },
    );
  }


}
// 数据检测 start
  /// _dataMonitoring 数据检测container
  Widget get _dataMonitoring {
    return Container(
        color: XColors.white,
        // 数据监测
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.fromLTRB(13.0, 0, 0, 6),
                alignment: Alignment.topLeft,
                child: Text("数据检测")),
            Container(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      // 面积图
                      // margin: EdgeInsets.all(13.0),
                      width: 380.0,
                      height: 100.0,
                      // color: Colors.red,
                      child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        series: <SplineAreaSeries<TemperatureData, String>>[
                          SplineAreaSeries<TemperatureData, String>(
                            dataSource: <TemperatureData>[
                              TemperatureData('Jan', 30, 18),
                              TemperatureData('Feb', 42, 20),
                              TemperatureData('Mar', 15, 22),
                              TemperatureData('Apr', 68, 25),
                              TemperatureData('May', 40, 28),
                              TemperatureData('Jun', 38, 27),
                              TemperatureData('Jul', 47, 26),
                              TemperatureData('Aug', 36, 25),
                              TemperatureData('Sep', 35, 24),
                              TemperatureData('Oct', 72, 22),
                              TemperatureData('Nov', 70, 20),
                              TemperatureData('Dec', 28, 18),
                            ],
                            xValueMapper: (TemperatureData temperature, _) =>
                                temperature.month,
                            yValueMapper: (TemperatureData temperature, _) =>
                                temperature.high,
                            // Optional: to show the range between high and low temperatures
                            // color can be customized as required
                            color: Colors.blue.withOpacity(0.2),
                            borderGradient: LinearGradient(
                              colors: [
                                Colors.blueAccent,
                                Colors.blue.withOpacity(0.4)
                              ],
                              stops: [0.2, 1],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderColor: Colors.blue,
                            borderWidth: 2,
                          ),
                        ],
                      ),
                    ),
                    // Container(
                    //   width: 11,
                    // ),
                    // Container(
                    //   // 柱状图
                    //   width: 180.0,
                    //   height: 80.0,
                    //   // color: Colors.green,
                    //   child: SfCartesianChart(
                    //       primaryXAxis: CategoryAxis(),
                    //       primaryYAxis:
                    //           NumericAxis(minimum: 0, maximum: 40, interval: 10),
                    //       tooltipBehavior: _tooltip,
                    //       series: <ChartSeries<_ChartData, String>>[
                    //         ColumnSeries<_ChartData, String>(
                    //             dataSource: data,
                    //             xValueMapper: (_ChartData data, _) => data.x,
                    //             yValueMapper: (_ChartData data, _) => data.y,
                    //             name: 'Gold',
                    //             color: Color.fromRGBO(8, 142, 255, 1))
                    //       ]),
                    // ),
                  ],
                ),
              ],
            )),
            Container(
              // 柱状图
              width: 380.0,
              height: 100.0,
              // color: Colors.green,
              child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  primaryYAxis:
                      NumericAxis(minimum: 0, maximum: 40, interval: 10),
                  tooltipBehavior: _tooltip,
                  series: <ChartSeries<_ChartData, String>>[
                    ColumnSeries<_ChartData, String>(
                        dataSource: data,
                        xValueMapper: (_ChartData data, _) => data.x,
                        yValueMapper: (_ChartData data, _) => data.y,
                        name: 'Gold',
                        color: Color.fromRGBO(8, 142, 255, 1))
                  ]),
            ),
            Container(
              height: 1,
            ),
            Container(
                child: Column(
              children: [
                Row(
                  children: [
                    Container(
                        // 饼图
                        width: 380.0,
                        height: 100.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            // BoxShadow(
                            //   color:
                            //       Color.fromARGB(255, 33, 27, 125).withOpacity(0.8),
                            //   spreadRadius: 5,
                            //   blurRadius: 7,
                            //   offset: Offset(0, 3), // changes position of shadow
                            // ),
                          ],
                          // border: Border.all(
                          //   color:
                          //       Color.fromARGB(255, 33, 27, 125).withOpacity(0.8),
                          //   width: 2,
                          // ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: EdgeInsets.all(13.0),

                        // color: Colors.red,
                        // child: PieChartWidget()
                        child: Container(
                          width: 180.0,
                          height: 180.0,
                          child: SfCircularChart(
                            // title: ChartTitle(text: 'Sales Data'),
                            // legend: Legend(isVisible: true),
                            series: <CircularSeries>[
                              PieSeries<pieChartSalesData, String>(
                                dataSource: <pieChartSalesData>[
                                  pieChartSalesData('Jan', 35),
                                  pieChartSalesData('Feb', 15),
                                  pieChartSalesData('Mar', 34),
                                  pieChartSalesData('Apr', 16),
                                  // pieChartSalesData('May', 40)
                                ],
                                xValueMapper: (pieChartSalesData sales, _) =>
                                    sales.year,
                                yValueMapper: (pieChartSalesData sales, _) =>
                                    sales.sales,
                                dataLabelSettings:
                                    DataLabelSettings(isVisible: true),
                              )
                            ],
                          ),
                        )),
                    // Container(
                    //   width: 11,
                    // ),
                    // Container(
                    //   width: 180.0,
                    //   height: 80.0,
                    //   // color: Colors.green,
                    //   child: ElevatedButton.icon(
                    //     style: ButtonStyle(
                    //         backgroundColor:
                    //             MaterialStateProperty.all(Colors.white)),
                    //     icon: Icon(
                    //       Icons.add,
                    //       color: Colors.grey,
                    //     ),
                    //     onPressed: () {
                    //       Get.defaultDialog();
                    //     },
                    //     // label: Text(menuItems[index]),
                    //     label: Text(''),
                    //   ),
                    // ),
                  ],
                ),
              ],
            )),
            Container(
              width: 11,
            ),
            SizedBox(
              width: 180.0,
              height: 80.0,
              // color: Colors.green,
              child: ElevatedButton.icon(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white)),
                icon: Icon(
                  size: 55,
                  Icons.add,
                  color: Colors.grey,
                ),
                onPressed: () {
                  Get.defaultDialog();
                },
                // label: Text(menuItems[index]),
                label: Text(''),
              ),
            ),
            SizedBox(
              height: 12.h,
            ),
          ],
        ));
  }
// 数据检测 end
class CardChildWidget extends StatelessWidget {
  String itemName;

  List value;

  CardChildWidget(this.itemName, this.value);

  @override
  Widget build(BuildContext context) {
    debugPrint("--->key:item$itemName | value :${value}");
    return Container(
        color: XColors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              itemName,
              // style: XFonts.size24Black3W700,
            ),
            SizedBox(
              height: 12.h,
            ),
            Container(
              // color: XColors.navigatorBgColor,

              child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.only(top: 10.h, bottom: 20.h),
                  shrinkWrap: true,
                  itemCount: value.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        var func = value[index]["func"];
                        if (func != null) {
                          func();
                        }
                      },
                      child: Column(
                        children: [
                          // AImage.netImageRadius(AIcons.back_black,
                          //     size: Size(64.w, 64.w)),
                          Container(
                            decoration: BoxDecoration(
                              // image: DecorationImage(
                              //     image: NetworkImage(
                              //         'https://s3.bmp.ovh/imgs/2023/02/28/3d1e012ec88ff534.jpg')),
                              borderRadius: BorderRadius.circular(60),
                              color: XColors.navigatorBgColor,
                            ),
                            width: 64.w,
                            height: 64.w,
                            // color: XColors.navigatorBgColor,
                          ),
                          // AImage.netImage(AIcons.placeholder,
                          //     url: value[index]['icon'], size: Size()),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text(
                            value[index]['cardName'],
                            style: XFonts.size18Black6,
                          ),
                        ],
                      ),
                    );
                  }),
            ),
          ],
        ));
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

class IndexPageController extends BaseController {}

class IndexPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => IndexPageController());
    Get.lazyPut(() => SearchBarController());
  }
}
