import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() => runApp(SplineAreaChart());

class SplineAreaChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Syncfusion Spline Area Chart',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Syncfusion Spline Area Chart'),
        ),
        body: SplineAreaChartWidget(),
      ),
    );
  }
}

class SplineAreaChartWidget extends StatefulWidget {
  @override
  _SplineAreaChartWidgetState createState() => _SplineAreaChartWidgetState();
}

class _SplineAreaChartWidgetState extends State<SplineAreaChartWidget> {
  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
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
          xValueMapper: (TemperatureData temperature, _) => temperature.month,
          yValueMapper: (TemperatureData temperature, _) => temperature.high,
          // Optional: to show the range between high and low temperatures
          // color can be customized as required
          color: Colors.blue.withOpacity(0.2),
          borderGradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.blue.withOpacity(0.4)],
            stops: [0.2, 1],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderColor: Colors.blue,
          borderWidth: 2,
        ),
      ],
    );
  }
}

class TemperatureData {
  final String month;
  final double high;
  final double low;

  TemperatureData(this.month, this.high, this.low);
}
