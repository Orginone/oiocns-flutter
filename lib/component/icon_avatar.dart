import 'package:flutter/material.dart';

import '../config/custom_colors.dart';

const double defaultWidth = 40;
const double defaultRadius = 5;
const EdgeInsets defaultInsets = EdgeInsets.all(15);
const Color defaultBgColor = Colors.blueAccent;

class IconAvatar extends StatelessWidget {
  final Icon icon;
  final double width;
  final double radius;
  final EdgeInsets padding;
  final Color bgColor;

  const IconAvatar(
      {Key? key,
      required this.icon,
      this.radius = defaultRadius,
      this.width = defaultWidth,
      this.padding = defaultInsets,
      this.bgColor = defaultBgColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    BorderRadius borderRadius = BorderRadius.all(Radius.circular(radius));
    return Container(
        padding: padding,
        decoration: BoxDecoration(color: bgColor, borderRadius: borderRadius),
        child: icon);
  }
}
