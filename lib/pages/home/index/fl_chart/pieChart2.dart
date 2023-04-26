import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
// 在此示例中，我们创建了一个PieChartWidget小部件，该小部件具有固定的宽度和高度，并且可以放置在容器的child属性中。饼图由三个部分组成，每个部分的颜色、半径、值和标题都有所不同。请注意，PieChartSectionData的radius属性控制部分的大小。

// 请确保您的项目中已添加fl_chart库的依赖项，并在需要使用饼图的地方将PieChartWidget小部件放置在适当的位置。
class PieChartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180.0,
      height: 50.0,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              color: Colors.blue,
              value: 35,
              title: '35%',
              radius: 30,
              titleStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            PieChartSectionData(
              color: Colors.red,
              value: 40,
              title: '40%',
              radius: 30,
              titleStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            PieChartSectionData(
              color: Colors.green,
              value: 25,
              title: '25%',
              radius: 30,
              titleStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
