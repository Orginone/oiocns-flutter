import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MyChartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Chart'),
      ),
      body: SfCircularChart(
        title: ChartTitle(text: 'Sales Data'),
        legend: Legend(isVisible: true),
        series: <CircularSeries>[
          PieSeries<pieChartSalesData, String>(
            dataSource: <pieChartSalesData>[
              pieChartSalesData('Jan', 35),
              pieChartSalesData('Feb', 28),
              pieChartSalesData('Mar', 34),
              pieChartSalesData('Apr', 32),
              pieChartSalesData('May', 40)
            ],
            xValueMapper: (pieChartSalesData sales, _) => sales.year,
            yValueMapper: (pieChartSalesData sales, _) => sales.sales,
            dataLabelSettings: DataLabelSettings(isVisible: true),
          )
        ],
      ),
    );
  }
}

class pieChartSalesData {
  final String year;
  final double sales;

  pieChartSalesData(this.year, this.sales);
}
