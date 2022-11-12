import 'package:flutter/material.dart';

const EdgeInsets defaultPadding = EdgeInsets.only(left: 15, top: 15, right: 15);
const Icon defaultOperate = Icon(Icons.keyboard_arrow_right);

class ChooseItem extends StatelessWidget {
  final Widget header;
  final Widget? body;
  final Widget? operate;
  final List<Widget>? content;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Function? func;
  final Color? bgColor;

  const ChooseItem({
    Key? key,
    required this.header,
    this.func,
    this.padding = defaultPadding,
    this.margin,
    this.operate = defaultOperate,
    this.body,
    this.content,
    this.bgColor,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 选择项
    List<Widget> row = [header];
    if (body != null) {
      row.add(Expanded(child: body!));
    }
    if (operate != null) {
      row.add(Container(
        alignment: Alignment.centerRight,
        child: operate!,
      ));
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
    Column all = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: column,
    );

    // 点击触发方法
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (func != null) {
          func!();
        }
      },
      child: Container(
        color: bgColor,
        margin: margin,
        padding: padding,
        child: all,
      ),
    );
  }
}
