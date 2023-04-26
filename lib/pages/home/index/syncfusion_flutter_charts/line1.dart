import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Syncfusion Flutter Charts Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final List<SalesData> chartData = [
    SalesData(2010, 35),
    SalesData(2011, 28),
    SalesData(2012, 34),
    SalesData(2013, 32),
    SalesData(2014, 40),
    SalesData(2015, 55),
    SalesData(2016, 58),
    SalesData(2017, 56),
    SalesData(2018, 40),
    SalesData(2019, 45),
    SalesData(2020, 48),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Syncfusion Flutter Charts Demo'),
      ),
      body: Center(
        child: SfCartesianChart(
          primaryXAxis: NumericAxis(),
          series: <LineSeries<SalesData, num>>[
            LineSeries<SalesData, num>(
              dataSource: chartData,
              xValueMapper: (SalesData sales, _) => sales.year,
              yValueMapper: (SalesData sales, _) => sales.sales,
            ),
          ],
        ),
      ),
    );
  }
}

class SalesData {
  SalesData(this.year, this.sales);

  final int year;
  final double sales;
}
