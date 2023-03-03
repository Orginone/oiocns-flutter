import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
// 代码中，我们定义了一个 BarChartWidget 组件，传入一个 List<double> 类型的 data，用于展示柱状图。在组件中，我们使用 BarChart 组件来生成柱状图，同时传入一个 BarChartData 对象来设置柱状图的数据和样式。

// 在 BarChartData 对象中，我们定义了柱状图的标题样式，包括底部的标题和左侧的刻度值。接着，我们使用 data 中的数据来生成每个柱子，通过 asMap() 将 data 转为 map 类型，再通过 map 函数来生成每个柱子的数据，最后通过 toList() 将柱子的数据列表传入 barGroups 属性中。

// 每个柱子的数据通过 BarChartGroupData 对象来定义，包括 x 轴位置和 barRods，barRods 属性是一个包含 BarChartRodData 对象的列表，每个 BarChartRodData 对象定义了柱子的高度、颜色和边框样式等。
// dependencies:
// fl_chart: ^0.37.0
class BarChartWidget extends StatelessWidget {
  List<double> data = [1.1, 1.2, 1.5, 1.2, 1.5, 1.2, 1.5];

  BarChartWidget();

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            drawBehindEverything: true,
            // margin: 10,
            // rotateAngle: 45,
            // getTitles: (double value) {
            // 这里返回每个柱子的标题
            // return 'Title ${value.toInt()}';
            // },
          ),
          leftTitles: AxisTitles(
              // showTitles: true,
              // margin: 10,
              // getTitles: (double value) {
              // 这里返回左侧的刻度值
              // return '${value.toInt()}';
              // },
              ),
        ),
        barGroups: data
            .asMap()
            .map(
              (index, value) => MapEntry(
                index,
                BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      // y: value,
                      // colors: [Colors.blue, Colors.lightBlueAccent],
                      width: 16,
                      borderRadius: BorderRadius.circular(8), toY: value,
                    ),
                  ],
                ),
              ),
            )
            .values
            .toList(),
      ),
    );
  }
}
