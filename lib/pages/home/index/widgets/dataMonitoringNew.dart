import 'package:flutter/material.dart';
import 'package:orginone/pages/home/index/anewchart/natural.dart';
import 'package:orginone/widget/unified.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DataMonitoringNew extends StatelessWidget {
  late List<ChartData> _chartData = getChartData();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: XColors.white,
      child: Column(
        children: [
          // 行政事业性国有资产
          Container(
            child: _InstitutionBuildChart(),
          ),
          // 企业国有资产
          Container(
            child: _enterpriseBuildChart(),
          ),
          // 自然资源
          Container(
            child: _naturalChart(),
          )
        ],
      ),
    );
  }

  Widget _naturalChart() {
    return SfCartesianChart(
      title: ChartTitle(text: '自然资源'),
      // legend: Legend(isVisible: true),
      tooltipBehavior: TooltipBehavior(enable: true),
      primaryYAxis: NumericAxis(
        labelStyle: TextStyle(
          color: Colors.transparent, // 将标签文本颜色设置为透明以隐藏它们
        ),
      ),
      series: <ColumnSeries>[
        ColumnSeries<ChartData, String>(
          name: '土地',
          dataSource: _chartData,
          xValueMapper: (ChartData data, _) => data.year,
          yValueMapper: (ChartData data, _) => data.land,
          borderRadius: BorderRadius.circular(10),
          width: 0.5,
          color: Colors.orange,
          onPointTap: (ChartPointDetails args) {
            final chartData = args.pointIndex!;
            final message =
                ' ${_chartData[chartData].year}年\n土地: ${_chartData[chartData].land}万公顷\n';
            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
          },
        ),
        ColumnSeries<ChartData, String>(
          name: '矿产',
          dataSource: _chartData,
          xValueMapper: (ChartData data, _) => data.year,
          yValueMapper: (ChartData data, _) => data.mineral.toDouble(),
          borderRadius: BorderRadius.circular(10),
          width: 0.5,
          color: Colors.green,
          onPointTap: (ChartPointDetails args) {
            final chartData = args.pointIndex!;
            final message =
                ' ${_chartData[chartData].year}年\n矿产: ${_chartData[chartData].mineral}种\n';
            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
          },
        ),
        ColumnSeries<ChartData, String>(
          name: '水资源',
          dataSource: _chartData,
          xValueMapper: (ChartData data, _) => data.year,
          yValueMapper: (ChartData data, _) => data.waterResources,
          borderRadius: BorderRadius.circular(10),
          width: 0.5,
          color: Colors.blue,
          onPointTap: (ChartPointDetails args) {
            final chartData = args.pointIndex!;
            final message =
                ' ${_chartData[chartData].year}年\n水资源: ${_chartData[chartData].waterResources}亿立方米\n';
            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
          },
        ),
      ],
      primaryXAxis: CategoryAxis(
          // title: AxisTitle(text: 'Year'),
          // interval: 1,
          ),
    );
  }

  List<ChartData> getChartData() {
    return <ChartData>[
      ChartData('2017', 156.27, 93, 895.35),
      ChartData('2018', 157.19, 93, 866.54),
      ChartData('2019', 157.2, 94, 1321.36),
      ChartData('2020', 180.35, 94, 1024.6),
      ChartData('2021', 181.2, 94, 1344.73),
    ];
  }
}

class ChartData {
  ChartData(this.year, this.land, this.mineral, this.waterResources);

  final String year;
  final double land;
  final int mineral;
  final double waterResources;
}

Widget _enterpriseBuildChart() {
  final List<Data> chartData = <Data>[
    Data(year: '2017', liabilities: 71781.38, equity: 28212.77),
    Data(year: '2018', liabilities: 99231.25, equity: 33300.78),
    Data(year: '2019', liabilities: 120926.54, equity: 38953.81),
    Data(year: '2020', liabilities: 149356.95, equity: 47895.48),
    Data(year: '2021', liabilities: 182383.3, equity: 67585.57),
  ];

  return Container(
    height: 500,
    child: SfCartesianChart(
      title: ChartTitle(text: '企业国有资产'),
      legend: Legend(
          isVisible: true,
          title: LegendTitle(text: "单位：亿元", alignment: ChartAlignment.center)),
      primaryXAxis: CategoryAxis(),
      primaryYAxis: NumericAxis(
        minimum: 0,
        maximum: 300000,
      ),
      series: _getSeries(chartData),
    ),
  );
}

List<StackedColumnSeries<Data, String>> _getSeries(List<Data> chartData) {
  return <StackedColumnSeries<Data, String>>[
    StackedColumnSeries<Data, String>(
      dataSource: chartData,
      xValueMapper: (Data data, _) => data.year,
      yValueMapper: (Data data, _) => data.equity,
      name: '净资产',
      dataLabelSettings: DataLabelSettings(
        isVisible: true,
        labelAlignment: ChartDataLabelAlignment.top,
      ),
    ),
    StackedColumnSeries<Data, String>(
      dataSource: chartData,
      xValueMapper: (Data data, _) => data.year,
      yValueMapper: (Data data, _) => data.liabilities,
      name: '负债',
      dataLabelSettings: DataLabelSettings(
        isVisible: true,
        labelAlignment: ChartDataLabelAlignment.top,
      ),
    ),
    StackedColumnSeries<Data, String>(
      dataSource: chartData,
      xValueMapper: (Data data, _) => data.year,
      yValueMapper: (Data data, _) => data.liabilities + data.equity,
      name: '总额',
      opacity: 0,
      dataLabelSettings: DataLabelSettings(
        isVisible: true,
        labelAlignment: ChartDataLabelAlignment.bottom,
      ),
    ),
  ];
}

class Data {
  Data({required this.year, required this.liabilities, required this.equity});

  final String year;
  final double liabilities;
  final double equity;
}

Widget _InstitutionBuildChart() {
  final List<InstitutionData> chartInstitutionData = <InstitutionData>[
    InstitutionData(year: '2017', liabilities: 4112.44, equity: 8605.22),
    InstitutionData(year: '2018', liabilities: 4004.56, equity: 9165.92),
    InstitutionData(year: '2019', liabilities: 4044.39, equity: 10167.79),
    InstitutionData(year: '2020', liabilities: 4461.32, equity: 11306.67),
    InstitutionData(year: '2021', liabilities: 4573.78, equity: 24132.16),
  ];

  return Container(
    height: 500,
    child: SfCartesianChart(
      title: ChartTitle(text: '行政事业性国有资产'),
      legend: Legend(
          isVisible: true,
          title: LegendTitle(text: "单位：亿元", alignment: ChartAlignment.center)),
      primaryXAxis: CategoryAxis(),
      primaryYAxis: NumericAxis(
        minimum: 0,
        maximum: 30000,
      ),
      series: _getchartInstitutionDataSeries(chartInstitutionData),
    ),
  );
}

List<StackedColumnSeries<InstitutionData, String>>
    _getchartInstitutionDataSeries(List<InstitutionData> chartData) {
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

class InstitutionData {
  InstitutionData(
      {required this.year, required this.liabilities, required this.equity});

  final String year;
  final double liabilities;
  final double equity;
}
