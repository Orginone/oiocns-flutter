import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
// 在这个示例代码中，我们使用了SfCartesianChart小部件创建了一个包含三个StackedColumnSeries的stacked column图表。每个StackedColumnSeries都表示月份的低温、高温和平均温度。我们还创建了一个TemperatureDataStackedColumnChart类来存储每个月份的温度数据。
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Stacked Column Chart Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Stacked Column Chart Demo'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: _buildStackedColumnChart(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStackedColumnChart() {
    return SfCartesianChart(
      title: ChartTitle(text: 'Monthly temperature comparison'),
      legend: Legend(isVisible: true),
      primaryXAxis: CategoryAxis(),
      series: _getStackedColumnSeries(),
    );
  }

  List<StackedColumnSeries<TemperatureDataStackedColumnChart, String>> _getStackedColumnSeries() {
    final List<TemperatureDataStackedColumnChart> data = [
      TemperatureDataStackedColumnChart('Jan', 12, 18, 6),
      TemperatureDataStackedColumnChart('Feb', 14, 20, 8),
      TemperatureDataStackedColumnChart('Mar', 17, 23, 10),
      TemperatureDataStackedColumnChart('Apr', 21, 27, 14),
      TemperatureDataStackedColumnChart('May', 25, 31, 18),
      TemperatureDataStackedColumnChart('Jun', 28, 34, 21),
      TemperatureDataStackedColumnChart('Jul', 30, 36, 23),
      TemperatureDataStackedColumnChart('Aug', 29, 35, 22),
      TemperatureDataStackedColumnChart('Sep', 26, 32, 19),
      TemperatureDataStackedColumnChart('Oct', 21, 27, 14),
      TemperatureDataStackedColumnChart('Nov', 16, 22, 9),
      TemperatureDataStackedColumnChart('Dec', 12, 18, 6),
    ];

    return [
      StackedColumnSeries<TemperatureDataStackedColumnChart, String>(
        name: 'Low',
        dataSource: data,
        xValueMapper: (TemperatureDataStackedColumnChart temperature, _) => temperature.month,
        yValueMapper: (TemperatureDataStackedColumnChart temperature, _) => temperature.low,
      ),
      StackedColumnSeries<TemperatureDataStackedColumnChart, String>(
        name: 'High',
        dataSource: data,
        xValueMapper: (TemperatureDataStackedColumnChart temperature, _) => temperature.month,
        yValueMapper: (TemperatureDataStackedColumnChart temperature, _) => temperature.high,
      ),
      StackedColumnSeries<TemperatureDataStackedColumnChart, String>(
        name: 'Average',
        dataSource: data,
        xValueMapper: (TemperatureDataStackedColumnChart temperature, _) => temperature.month,
        yValueMapper: (TemperatureDataStackedColumnChart temperature, _) => temperature.average,
      ),
    ];
  }
}

class TemperatureDataStackedColumnChart {
  TemperatureDataStackedColumnChart(this.month, this.high, this.low, this.average);

  final String month;
  final double high;
  final double low;
  final double average;
}
