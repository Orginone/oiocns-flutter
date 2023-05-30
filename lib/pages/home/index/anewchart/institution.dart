import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Syncfusion Flutter Charts',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Syncfusion Flutter Charts'),
        ),
        body: Center(
          child: _InstitutionBuildChart(),
        ),
      ),
    );
  }

  Widget _InstitutionBuildChart() {
    final List<InstitutionData> chartData = <InstitutionData>[
      InstitutionData(year: '2017', liabilities: 4112.44, equity: 8605.22),
      InstitutionData(year: '2018', liabilities: 4004.56, equity: 9165.92),
      InstitutionData(year: '2019', liabilities: 4044.39, equity: 10167.79),
      InstitutionData(year: '2020', liabilities: 4461.32, equity: 11306.67),
      InstitutionData(year: '2021', liabilities: 4573.78, equity: 24132.16),
    ];

    return Container(
      height: 500,
      child: SfCartesianChart(
        title: ChartTitle(text: '2017年-2021年 财务数据'),
        legend: Legend(isVisible: true, title: LegendTitle(text: "单位：亿元",alignment: ChartAlignment.center)),
        primaryXAxis: CategoryAxis(),
        series: _getSeries(chartData),
      ),
    );
  }

  List<StackedColumnSeries<InstitutionData, String>> _getSeries(List<InstitutionData> chartData) {
    return <StackedColumnSeries<InstitutionData, String>>[
      StackedColumnSeries<InstitutionData, String>(
        dataSource: chartData,
        xValueMapper: (InstitutionData data, _) => data.year,
        yValueMapper: (InstitutionData data, _) => data.equity,
        name: '净资产',
        dataLabelSettings: DataLabelSettings(
          isVisible: true,
          labelAlignment: ChartDataLabelAlignment.top,
        ),
      ),
      StackedColumnSeries<InstitutionData, String>(
        dataSource: chartData,
        xValueMapper: (InstitutionData data, _) => data.year,
        yValueMapper: (InstitutionData data, _) => data.liabilities,
        name: '负债',
        dataLabelSettings: DataLabelSettings(
          isVisible: true,
          labelAlignment: ChartDataLabelAlignment.top,
        ),
      ),
      StackedColumnSeries<InstitutionData, String>(
        dataSource: chartData,
        xValueMapper: (InstitutionData data, _) => data.year,
        yValueMapper: (InstitutionData data, _) => data.liabilities + data.equity,
        name: '总额',
        opacity: 0,
        dataLabelSettings: DataLabelSettings(
          isVisible: true,
          labelAlignment: ChartDataLabelAlignment.bottom,
        ),
      ),
    ];
  }
}

class InstitutionData {
  InstitutionData({required this.year, required this.liabilities, required this.equity});

  final String year;
  final double liabilities;
  final double equity;
}
