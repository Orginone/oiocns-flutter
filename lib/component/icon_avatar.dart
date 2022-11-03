import 'package:flutter/material.dart';

const double defaultRadius = 5;
const EdgeInsets defaultInsets = EdgeInsets.all(12);
const Color defaultBgColor = Colors.blueAccent;

class IconAvatar extends StatelessWidget {
  final Icon icon;
  final double radius;
  final EdgeInsets padding;
  final Color bgColor;
  final double? width;

  const IconAvatar({
    Key? key,
    required this.icon,
    this.width,
    this.radius = defaultRadius,
    this.padding = defaultInsets,
    this.bgColor = defaultBgColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: width,
      alignment: Alignment.center,
      padding: padding,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.all(Radius.circular(radius)),
      ),
      child: icon,
    );
  }
}
