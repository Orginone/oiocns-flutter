import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/widget/unified.dart';
import 'package:orginone/pages/index/index_page.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DataMonitoring extends StatelessWidget {
  DataMonitoring({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
