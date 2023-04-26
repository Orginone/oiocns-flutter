import 'package:flutter/material.dart';
import 'package:orginone/pages/home/index/widgets/dataMonitoring.dart';

import 'searchBarWidget.dart';

class IndexNewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        CustomSearchBar(
          onAddClicked: () {
            // 处理添加按钮的点击事件
          },
        ),
        Container(
          height: 20,
        ),
        DataMonitoring()
      ],
    ));
  }
}
