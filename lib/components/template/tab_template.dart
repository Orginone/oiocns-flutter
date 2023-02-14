import 'package:flutter/material.dart';

/// Tab 模板
class TabTemplate extends StatelessWidget {
  final Widget? top;
  final List<Widget> views;
  final Widget? bottom;
  final TabController tabCtrl;

  const TabTemplate({
    super.key,
    this.top,
    required this.views,
    this.bottom,
    required this.tabCtrl,
  });

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];
    if (top != null) {
      children.add(top!);
    }
    children.add(_main(views));
    if (bottom != null) {
      children.add(bottom!);
    }
    return Column(children: children);
  }

  Widget _main(List<Widget> children) {
    return Expanded(child: TabBarView(children: children));
  }
}
