import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const EdgeInsets defaultPadding = EdgeInsets.only(left: 15, top: 15, right: 15);

class ChooseItem extends StatelessWidget {
  final Widget header;
  final Widget? body;
  final Widget? operate;
  final List<Widget>? content;
  final EdgeInsets? padding;
  final Function func;

  const ChooseItem(
      {Key? key,
      required this.header,
      required this.func,
      this.padding = defaultPadding,
      this.operate,
      this.body,
      this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 选择项
    List<Widget> row = [header];
    if (body != null) {
      row.add(body!);
    }
    if (operate != null) {
      row.add(operate!);
    }
    Row chooseItem = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: row,
    );

    // 垂直数据
    List<Widget> column = [];
    column.add(chooseItem);
    if (content != null) {
      column.addAll(content!);
    }
    Column all = Column(children: column);

    // 点击触发方法
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        func();
      },
      child: Container(
        padding: padding,
        child: all,
      ),
    );
  }
}
