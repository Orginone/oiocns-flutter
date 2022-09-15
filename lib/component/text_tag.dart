import 'package:flutter/material.dart';

import '../config/custom_colors.dart';

const TextStyle defaultTextStyle = TextStyle(
    fontSize: 9, color: Colors.blueAccent, fontWeight: FontWeight.bold);
const Color defaultBgColor = CustomColors.lightBlue;

class TextTag extends StatelessWidget {
  final String? label;
  final TextStyle textStyle;
  final Color? bgColor;

  const TextTag(this.label,
      {this.textStyle = defaultTextStyle,
      this.bgColor = defaultBgColor,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(
            color: bgColor,
            borderRadius: const BorderRadius.all(Radius.circular(5))),
        padding: const EdgeInsets.all(2),
        child: Text(
          label ?? "",
          style: defaultTextStyle,
        ));
  }
}
