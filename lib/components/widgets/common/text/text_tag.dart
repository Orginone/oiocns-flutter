import 'package:flutter/material.dart';
import 'package:orginone/config/colors.dart';
import 'package:orginone/config/text.dart';

const EdgeInsets defaultPadding = EdgeInsets.all(2);
const double defaultRadius = 3;

class TextTag extends StatelessWidget {
  final String label;
  final TextStyle textStyle;
  final Color? bgColor;
  final Color? borderColor;
  final EdgeInsets? padding;
  final double radius;
  final Function? onTap;
  final Function? onPanDown;
  final int? maxLines;
  const TextTag(
    this.label, {
    this.textStyle = AppTextStyles.defaultTextStyle,
    this.bgColor = AppColors.defaultBgColor,
    this.borderColor,
    this.padding = defaultPadding,
    this.radius = defaultRadius,
    this.onTap,
    this.onPanDown,
    Key? key,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
      onPanDown: (details) {
        if (onPanDown != null) {
          onPanDown!(details);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          border: borderColor == null
              ? null
              : Border.all(color: borderColor!, width: 0.5),
        ),
        padding: padding,
        child: Text(
          label,
          style: textStyle,
          maxLines: maxLines,
        ),
      ),
    );
  }
}
