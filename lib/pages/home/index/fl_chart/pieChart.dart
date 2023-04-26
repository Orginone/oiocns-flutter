import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
// 在此代码中，PieChartData 包含了以下配置：

// sections：一个 List，包含了所有的饼状图数据。每个数据由 PieChartSectionData 对象表示。
// centerSpaceRadius：一个 double 类型的值，表示空心圆的半径大小。如果该值为 0，则饼状图没有空心。
// centerSpaceColor：一个 Color 类型的值，表示空心圆的颜色。
// borderData：一个 FlBorderData 对象，表示饼状图的边框。您可以使用该对象的 show 属性来控制边框是否可见，使用 border 属性来设置边框的样式。
// sectionsSpace：一个 double 类型的值，表示饼状图中每个扇形之间的间隔大小。
// sectionsRadius：一个 double 类型的值，表示饼状图中每个扇形的半径大小。这里的半径是相对于整个饼状图的半径的比例。
class PieChartSample extends StatefulWidget {
  @override
  _PieChartSampleState createState() => _PieChartSampleState();
}

class _PieChartSampleState extends State<PieChartSample> {
  // 定义数据
  final List<PieChartSectionData> data = [
    PieChartSectionData(
      title: 'A',
      value: 30,
      color: Colors.blue,
    ),
    PieChartSectionData(
      title: 'B',
      value: 20,
      color: Colors.green,
    ),
    PieChartSectionData(
      title: 'C',
      value: 50,
      color: Colors.yellow,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pie Chart Sample'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: PieChart(
          // 数据配置
          PieChartData(
            // 数据源
            sections: data,
            // 空心圆配置
            centerSpaceRadius: 40,
            centerSpaceColor: Colors.white,
            // 边框配置
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: Colors.grey, width: 1),
            ),
            // 饼图绘制偏移角度
            sectionsSpace: 0,
            // 饼图半径比例
            // sectionsRadius: 100,
          ),
        ),
      ),
    );
  }
}
