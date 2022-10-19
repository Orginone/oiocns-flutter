import 'package:flutter/material.dart';

import 'unified_colors.dart';

const TextStyle defaultTextStyle = TextStyle(
    fontSize: 8, color: Colors.blueAccent, fontWeight: FontWeight.bold);
const Color defaultBgColor = UnifiedColors.lightBlue;
const EdgeInsets defaultPadding = EdgeInsets.all(2);

class TextTag extends StatelessWidget {
  final String? label;
  final TextStyle textStyle;
  final Color? bgColor;
  final EdgeInsets? padding;

  const TextTag(this.label,
      {this.textStyle = defaultTextStyle,
      this.bgColor = defaultBgColor,
      this.padding = defaultPadding,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(
            color: bgColor,
            borderRadius: const BorderRadius.all(Radius.circular(5))),
        padding: padding,
        child: Text(
          label ?? "",
          style: textStyle,
        ));
  }
}
