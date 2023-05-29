import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Column Chart Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Column Chart Demo'),
        ),
        body: ColumnChart(),
      ),
    );
  }
}

class ColumnChart extends StatefulWidget {
  @override
  _naturalChartState createState() => _naturalChartState();
}

class _naturalChartState extends State<ColumnChart> {
  late List<ChartData> _chartData;

  @override
  void initState() {
    _chartData = getChartData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      title: ChartTitle(text: 'Land, Mineral and Water Resources'),
      legend: Legend(isVisible: true),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <ColumnSeries>[
        ColumnSeries<ChartData, String>(
          name: 'Land',
          dataSource: _chartData,
          xValueMapper: (ChartData data, _) => data.year,
          yValueMapper: (ChartData data, _) => data.land,
          borderRadius: BorderRadius.circular(10),
          width: 0.5,
          color: Colors.orange,
          onPointTap: (ChartPointDetails args) {
            final chartData = args.pointIndex!;
            final message =
                'Year: ${_chartData[chartData].year}\nLand: ${_chartData[chartData].land}';
            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
          },
        ),
        ColumnSeries<ChartData, String>(
          name: 'Mineral',
          dataSource: _chartData,
          xValueMapper: (ChartData data, _) => data.year,
          yValueMapper: (ChartData data, _) => data.mineral.toDouble(),
          borderRadius: BorderRadius.circular(10),
          width: 0.5,
          color: Colors.green,
          onPointTap: (ChartPointDetails args) {
            final chartData = args.pointIndex!;
            final message =
                'Year: ${_chartData[chartData].year}\nMineral: ${_chartData[chartData].mineral}';
            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
          },
        ),
        ColumnSeries<ChartData, String>(
          name: 'Water Resources',
          dataSource: _chartData,
          xValueMapper: (ChartData data, _) => data.year,
          yValueMapper: (ChartData data, _) => data.waterResources,
          borderRadius: BorderRadius.circular(10),
          width: 0.5,
          color: Colors.blue,
          onPointTap: (ChartPointDetails args) {
            final chartData = args.pointIndex!;
            final message =
                'Year: ${_chartData[chartData].year}\nWater Resources: ${_chartData[chartData].waterResources}';
            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
          },
        ),
      ],
      primaryXAxis: CategoryAxis(
        title: AxisTitle(text: 'Year'),
        interval: 1,
      ),
      primaryYAxis: NumericAxis(
        title: AxisTitle(text: 'Resources in Billions'),
        labelFormat: '{value}',
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
