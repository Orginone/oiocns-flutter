import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
// 在上面的示例中，我们定义了一个名为CircularChartData的类，用于存储温度数据的位置和温度值。然后我们使用getCircularChartData函数生成一组温度数据，并将其传递给DoughnutSeries的dataSource属性。我们还使用xValueMapper和yValueMapper属性将数据源中的位置和温度值映射到图表上。最后，我们还定义了数据标签映射函数dataLabelMapper，以便在数据标签中显示温度值。

// 在图表的其他属性中，我们使用了ChartTitle小部件定义了标题，Legend小部件启用了图例，DoughnutSeries的radius和innerRadius属性定义了饼图的大小和内部空心圆的大小，DataLabelSettings启用了数据标签并设置了一些样式。
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Syncfusion Flutter Charts',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Syncfusion Flutter Charts - Doughnut Chart'),
        ),
        body: Center(
          child: SfCircularChart(
            // title: ChartTitle(text: 'Temperature Data'),
            legend: Legend(isVisible: true),
            series: <CircularSeries>[
              DoughnutSeries<CircularChartData, String>(
                dataSource: getCircularChartData(),
                xValueMapper: (CircularChartData data, _) => data.place,
                yValueMapper: (CircularChartData data, _) => data.temperature,
                dataLabelMapper: (CircularChartData data, _) =>
                    '${data.temperature}°C',
                radius: '40%',
                innerRadius: '60%',
                dataLabelSettings: DataLabelSettings(isVisible: true),
              )
            ],
          ),
        ),
      ),
    );
  }
}

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
