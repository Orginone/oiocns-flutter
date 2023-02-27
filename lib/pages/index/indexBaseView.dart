import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:logging/logging.dart';
import 'package:orginone/components/template/base_view.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/config/enum.dart';
import 'package:orginone/pages/index/ScrollableMenu.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

/// 设置首页
@immutable
class IndexPage extends BaseView<IndexPageController> {
  final Logger log = Logger("SetHomePage");

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
      {"id": 0, "icon": "icon", "cardName": "资产应用一"},
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
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: '搜索',
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: '增加',
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_horiz_outlined),
            tooltip: '更多',
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                '抽屉',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Favorite'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.wallet),
              title: const Text('wallet'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: ListView(
          shrinkWrap: true,
          // padding: const EdgeInsets.all(20.0),
          children: <Widget>[
            _carousel(imageList),
            SizedBox(
              height: 12.h,
            ),
            Container(
                decoration: BoxDecoration(
                    color: XColors.white,
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.fromLTRB(11.0, 0, 0, 0),
                alignment: Alignment.topLeft,
                child: const Text("快捷入口")),
            // _expressEntrance(),
            ScrollableMenu(),
            SizedBox(
              height: 12.h,
            ),
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
            _dataMonitoring(),
          ]),
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

// 数据检测 start
  /// _dataMonitoring 数据检测container
  Widget _dataMonitoring() {
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
}

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
              decoration: BoxDecoration(
                  color: XColors.white,
                  borderRadius: BorderRadius.circular(10)),
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
                              width: 64.w,
                              height: 64.w,
                              color: XColors.navigatorBgColor),
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
  }
}
