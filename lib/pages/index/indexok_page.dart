import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:logging/logging.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/pages/index/ScrollableMenu.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:orginone/pages/index/fl_chart/pieChart2.dart';
// import 'package:orginone/pages/index/syncfusion_flutter_charts/splineArea.dart'

// TODO 先完成界面设计，再完成功能，界面兼容性，最后整理代码

class IndexPageLowVersion extends StatefulWidget {
  static final Logger log = Logger("UintSettingsPage");
  static final LinkedHashMap map = LinkedHashMap();

  IndexPageLowVersion({Key? key}) : super(key: key) {
    map["配置中心"] = [
      {"id": 0, "icon": "icon", "cardName": "单位设置"},
      {"id": 1, "icon": "icon", "cardName": "数据设置"},
      {"id": 2, "icon": "icon", "cardName": "应用设置"},
      {"id": 4, "icon": "icon", "cardName": "流程设置"},
      {"id": 5, "icon": "icon", "cardName": "标准设置"},
      {"id": 6, "icon": "icon", "cardName": "权限设置"},
      {"id": 6, "icon": "icon", "cardName": "权限设置"},
      {
        "id": 7,
        "icon": "icon",
        "cardName": "更新版本",
        "func": () {
          // Get.toNamed(Routers.version);
        }
      },
      {"id": 8, "icon": "icon", "cardName": "标准设置11"},
      {"id": 9, "icon": "icon", "cardName": "权限设置22"},
    ];
  }
    List<Widget> _getItems() {
    List<Widget> children = [];
    debugPrint("--->size:${map.length}");
    map.forEach((key, value) {
      children.add(CardChildWidget(key, value));
    });
    return children;
  }
    Widget _commonApplicationsGenerate(BuildContext context) {
    return Container(
      color: XColors.bgColor,
      padding: EdgeInsets.only(left: 12.w, right: 12.w),
      child: ListView(
        shrinkWrap: true,
        children: _getItems()
          ..add(Container(
            margin: EdgeInsets.only(left: 20.w, bottom: 10.h, right: 20.w),
          )),
      ),
    );
  }
  @override
  _SwiperPageState createState() => _SwiperPageState();
}

class _SwiperPageState extends State<IndexPageLowVersion> {
  
  // 轮播图片
  List<String> imageList = [
    "images/bg_center1.png",
    "images/bg_center2.png",
    "images/bg_center1.png",
    "images/bg_center2.png",
  ];

  @override
  Widget build(BuildContext context) {
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
            // _topMemuRowButton(),
            _carousel(imageList),
            Container(
                padding: const EdgeInsets.fromLTRB(11.0, 0, 0, 0),
                alignment: Alignment.topLeft,
                child: const Text("快捷入口")),
            // _expressEntrance(),
            ScrollableMenu(),
            // _commonApplicationsGenerate(),
            _commonApplications(),
            // _dataMonitoring(),
            _dataMonitoringListView(),
          ]),
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //       body: Column(children: <Widget>[
  //     _topMemuRowButton(),
  //     _carousel(imageList),
  //     Container(
  //         padding: const EdgeInsets.fromLTRB(11.0, 0, 0, 0),
  //         alignment: Alignment.topLeft,
  //         child: Text("快捷入口")),
  //     // _expressEntrance(),
  //     ScrollableMenu(),
  //     _commonApplications(),
  //     // _dataMonitoring(),
  //     _dataMonitoringListView(),
  //   ]));
  // }

// 封装widget start
  /// _topMemuRowButton 顶部菜单行按钮（4个按钮：主页、搜索、添加、操作）
  ///
  ///  @param
  ///
  /// @returns Widget
  Widget _topMemuRowButton() {
    return Row(
      children: <Widget>[
        Container(
          alignment: Alignment.bottomLeft,
          height: 30,
          width: 130,
          child: OutlinedButton.icon(
              onPressed: () {
                Get.snackbar("Snackbar 标题", "欢迎使用Snackbar");
              },
              icon: Icon(Icons.cabin_sharp),
              label: Text("")),
        ),
        const SizedBox(
          height: 30,
          width: 75,
        ),
        Wrap(
          spacing: 4,
          children: [
            OutlinedButton.icon(
                onPressed: () {
                  Get.snackbar("Snackbar 标题", "欢迎使用Snackbar");
                },
                icon: Icon(Icons.search),
                label: Text("")),
            OutlinedButton.icon(
                onPressed: () {
                  Get.snackbar("Snackbar 标题", "欢迎使用Snackbar");
                },
                icon: Icon(Icons.add),
                label: Text("")),
            OutlinedButton.icon(
                onPressed: () {
                  Get.snackbar("Snackbar 标题", "欢迎使用Snackbar");
                },
                icon: Icon(Icons.format_line_spacing_outlined),
                label: Text("")),
          ],
        ),
      ],
    );
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
      aspectRatio: 6 / 2,
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
      onPageChanged: (index) {
        setState(() {
          index;
        });
      },
    );
  }

  /// _expressEntrance 快捷入口
  Widget _expressEntrance() {
    return Container(
      // 快捷入口
      child: Column(
        children: [
          Container(
              padding: const EdgeInsets.fromLTRB(11.0, 0, 0, 0),
              alignment: Alignment.topLeft,
              child: const Text("快捷入口")),
          Container(
            padding: const EdgeInsets.fromLTRB(11.0, 0, 0, 0),
            child: Row(
              children: [
                Container(
                  width: 60.0,
                  height: 60.0,
                  color: Colors.red,
                ),
                SizedBox(width: 20),
                Container(
                  width: 60.0,
                  height: 60.0,
                  color: Colors.green,
                ),
                SizedBox(width: 20),
                Container(
                  width: 60.0,
                  height: 60.0,
                  color: Colors.blue,
                ),
                SizedBox(width: 20),
                Container(
                  width: 60.0,
                  height: 60.0,
                  color: Colors.green,
                ),
                SizedBox(width: 20),
                Container(
                  width: 60.0,
                  height: 60.0,
                  color: Colors.blue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// _commonApplicationsGenerate 常用应用 start



  /// _commonApplicationsGenerate 常用应用 end

  /// _commonApplications 常用应用
  Widget _commonApplications() {
    return Container(
        // 常用应用
        child: Column(
      children: [
        Container(
            padding: const EdgeInsets.fromLTRB(11.0, 0, 0, 0),
            alignment: Alignment.topLeft,
            child: Text("常用应用")),
        Flow(
          delegate: TestFlowDelegate(margin: EdgeInsets.all(10.0)),
          children: <Widget>[
            Container(
              width: 60.0,
              height: 60.0,
              // color: Colors.red,
              decoration: BoxDecoration(
                  image: const DecorationImage(
                      image: AssetImage("images/bg_center1.png"),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(1000)),
              child: const Text(
                '资产监管平台',
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.center, // 文本水平对齐方式
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              width: 60.0,
              height: 60.0,
              // color: Colors.blue,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("images/bg_center1.png"),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(1000)),
            ),
            Container(
              width: 60.0,
              height: 60.0,
              // color: Colors.blue,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("images/bg_center1.png"),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(1000)),
            ),
            Container(
              width: 60.0,
              height: 60.0,
              // color: Colors.yellow,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("images/bg_center1.png"),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(1000)),
            ),
            Container(
              width: 60.0,
              height: 60.0,
              // color: Colors.brown,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("images/bg_center1.png"),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(1000)),
            ),
            Container(
              width: 60.0,
              height: 60.0,
              // color: Colors.purple,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("images/bg_center1.png"),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(1000)),
            ),
            Container(
              width: 60.0,
              height: 60.0,
              // color: Colors.blue,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("images/bg_center1.png"),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(1000)),
            ),
            Container(
              width: 60.0,
              height: 60.0,
              // color: Colors.yellow,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("images/bg_center1.png"),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(1000)),
            ),
            Container(
              width: 60.0,
              height: 60.0,
              // color: Colors.brown,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("images/bg_center1.png"),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(1000)),
            ),
            Container(
              width: 60.0,
              height: 60.0,
              // color: Colors.purple,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("images/bg_center1.png"),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(1000)),
            ),
          ],
        ),
      ],
    ));
  }

  ///   _dataMonitoringListView  数据检测ListView
  Widget _dataMonitoringListView() {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(20.0),
      children: <Widget>[_dataMonitoring(), _dataMonitoring()],
    );
  }

  /// _dataMonitoring 数据检测container
  Widget _dataMonitoring() {
    return Container(
        // 数据监测
        child: Column(
      children: [
        Container(
            padding: const EdgeInsets.fromLTRB(11.0, 0, 0, 0),
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
                  margin: EdgeInsets.all(13.0),
                  width: 300.0,
                  height: 80.0,
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
          height: 1,
        ),
        Container(
            child: Column(
          children: [
            Row(
              children: [
                Container(
                    // 饼图
                    width: 300.0,
                    height: 80.0,
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
                      border: Border.all(
                        color:
                            Color.fromARGB(255, 33, 27, 125).withOpacity(0.8),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.all(13.0),

                    // color: Colors.red,
                    // child: PieChartWidget()
                    child: Container(
                      width: 180.0,
                      height: 80.0,
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
      ],
    ));
  }

// 封装widget end
}

// 初始化数据 start
class TemperatureData {
  final String month;
  final double high;
  final double low;

  TemperatureData(this.month, this.high, this.low);
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}

// 2222222
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

// 222222222

// 333333333333333
class CircularChartData {
  final String place;
  final double temperature;

  CircularChartData(this.place, this.temperature);
}

List<CircularChartData> getCircularChartData() {
  return <CircularChartData>[
    CircularChartData('New York', 25),
    CircularChartData('Paris', 20),
    CircularChartData('Tokyo', 28),
    CircularChartData('Sydney', 30),
    CircularChartData('London', 18),
  ];
}
// 333333333333333

// 33333333333333++++
class pieChartSalesData {
  final String year;
  final double sales;

  pieChartSalesData(this.year, this.sales);
}
// 33333333333333++++
// 初始化数据 end

class TestFlowDelegate extends FlowDelegate {
  EdgeInsets margin;

  TestFlowDelegate({this.margin = EdgeInsets.zero});

  double width = 0;
  double height = 0;

  @override
  void paintChildren(FlowPaintingContext context) {
    var x = margin.left;
    var y = margin.top;
    //计算每一个子widget的位置
    for (int i = 0; i < context.childCount; i++) {
      var w = context.getChildSize(i)!.width + x + margin.right;
      if (w < context.size.width) {
        context.paintChild(i, transform: Matrix4.translationValues(x, y, 0.0));
        x = w + margin.left;
      } else {
        x = margin.left;
        y += context.getChildSize(i)!.height + margin.top + margin.bottom;
        //绘制子widget(有优化)
        context.paintChild(i, transform: Matrix4.translationValues(x, y, 0.0));
        x += context.getChildSize(i)!.width + margin.left + margin.right;
      }
    }
  }

  @override
  Size getSize(BoxConstraints constraints) {
    // 指定Flow的大小，简单起见我们让宽度竟可能大，但高度指定为200，
    // 实际开发中我们需要根据子元素所占用的具体宽高来设置Flow大小
    return Size(double.infinity, 160.0);
  }

  @override
  bool shouldRepaint(FlowDelegate oldDelegate) {
    return oldDelegate != this;
  }
}

class CardChildWidget extends StatelessWidget {
  String itemName;

  List value;

  CardChildWidget(this.itemName, this.value);

  @override
  Widget build(BuildContext context) {
    debugPrint("--->key:item$itemName | value :${value}");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          itemName,
          style: XFonts.size24Black3W700,
        ),
        SizedBox(
          height: 12.h,
        ),
        Container(
          decoration: BoxDecoration(
              color: XColors.white, borderRadius: BorderRadius.circular(10)),
          child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(top: 20.h, bottom: 20.h),
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
        SizedBox(
          height: 24.h,
        ),
      ],
    );
  }
}
