import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartSample extends StatefulWidget {
  const LineChartSample({super.key});

  @override
  _LineChartSampleState createState() => _LineChartSampleState();
}

class _LineChartSampleState extends State<LineChartSample> {
  // 定义数据
  final List<FlSpot> data = [
    FlSpot(0, 1),
    FlSpot(1, 1.5),
    FlSpot(2, 1.4),
    FlSpot(3, 3),
    FlSpot(4, 4),
    FlSpot(5, 3.5),
    FlSpot(6, 5),
    FlSpot(7, 6),
    FlSpot(8, 8),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Line Chart Sample'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: LineChart(
          // 数据线
          LineChartData(
            // 网格线配置
            gridData: FlGridData(
              show: true,
              getDrawingHorizontalLine: (value) => FlLine(
                color: Colors.grey,
                strokeWidth: 0.5,
                dashArray: [5],
              ),
              getDrawingVerticalLine: (value) => FlLine(
                color: Colors.grey,
                strokeWidth: 0.5,
                dashArray: [5],
              ),
            ),
            // X轴配置
            minX: 0,
            maxX: 8,
            // Y轴配置
            minY: 0,
            maxY: 10,
            // 数据线配置
            lineBarsData: [
              LineChartBarData(
                spots: data,
                isCurved: true,
                // colors: [Colors.blue],
                barWidth: 2,
                dotData: FlDotData(
                  show: false,
                ),
              ),
            ],
            // 边框配置
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: Colors.grey, width: 1),
            ),
          ),
          // Y轴标题
          // yAxisTitleData: FlAxisTitleData(
          //   leftTitle: AxisTitle(
          //     titleText: 'Y Axis',
          //     textStyle: TextStyle(
          //       fontSize: 12,
          //       fontWeight: FontWeight.bold,
          //     ),
          //     margin: 10,
          //   ),
          // ),
          // // X轴标题
          // xAxisTitleData: FlAxisTitleData(
          //   bottomTitle: AxisTitle(
          //     titleText: 'X Axis',
          //     textStyle: TextStyle(
          //       fontSize: 12,
          //       fontWeight: FontWeight.bold,
          //     ),
          //     margin: 10,
          //   ),
          // ),
        ),
      ),
    );
  }
}
