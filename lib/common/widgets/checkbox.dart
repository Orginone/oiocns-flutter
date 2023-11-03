import 'package:flutter/material.dart';

import '../index.dart';

/// CheckBox 选择框
class CheckBoxWidget extends StatelessWidget {
  final bool value;
  final Function(bool value)? onChanged;

  /// 中间 icon
  final Widget? icon;
  final Widget? iconChecked;
  final double? fontSize;
  final Color? fontColor;

  /// 大小
  final double? size;

  /// 外框
  final Color? bgColor;
  final Color? bgColorChecked;
  final bool? isBorder;
  final Color? borderColor;

  /// 文本
  final Widget? label;
  final double? space;

  CheckBoxWidget({
    Key? key,
    required this.value,
    this.onChanged,
    this.size = 20,
    this.bgColor,
    this.bgColorChecked,
    this.fontSize = 14,
    this.fontColor,
    this.isBorder = true,
    this.borderColor,
    this.label,
    this.space = 14,
    this.icon,
    Widget? iconChecked,
  })  : iconChecked = iconChecked ??
            IconWidget.icon(
              Icons.check,
              size: fontSize,
              color: fontColor ?? AppColors.onPrimaryContainer,
            ),
        super(key: key);

  /// 样式1 - 全选
  CheckBoxWidget.all(
    this.value,
    this.onChanged, {
    Key? key,
    Color? borderColor,
    this.fontColor,
    this.fontSize = 16,
    this.size = 24,
    this.bgColor,
    this.bgColorChecked,
    this.isBorder = true,
    this.label,
    double? space,
    this.icon,
    Widget? iconChecked,
  })  : borderColor = borderColor ?? AppColors.outline,
        space = space ?? AppSpace.iconTextSmail,
        iconChecked = iconChecked ??
            IconWidget.icon(
              Icons.check,
              size: fontSize,
              color: fontColor ?? AppColors.onPrimaryContainer,
            ),
        super(key: key);

  /// 样式3 - 行选中
  CheckBoxWidget.radio(
    this.value,
    this.onChanged, {
    Key? key,
    this.borderColor,
    this.fontColor,
    this.fontSize = 18,
    this.size,
    this.bgColor,
    this.bgColorChecked,
    this.isBorder = false,
    this.label,
    double? space,
    Widget? icon,
    Widget? iconChecked,
  })  : icon = icon ??
            IconWidget.icon(
              Icons.radio_button_unchecked,
              size: fontSize,
              color: fontColor ?? AppColors.highlight,
            ),
        iconChecked = iconChecked ??
            IconWidget.icon(
              Icons.radio_button_checked,
              size: fontSize,
              color: fontColor ?? AppColors.highlight,
            ),
        space = space ?? AppSpace.iconTextSmail,
        super(key: key);

  /// 样式2 - 行选中 无边框
  CheckBoxWidget.single(
    this.value,
    this.onChanged, {
    Key? key,
    this.borderColor,
    this.fontColor,
    this.fontSize = 14,
    this.size = 20,
    Color? bgColor,
    Color? bgColorChecked,
    this.isBorder = false,
    this.label,
    double? space,
    this.icon,
    Widget? iconChecked,
  })  : iconChecked = iconChecked ??
            IconWidget.icon(
              Icons.check,
              size: fontSize,
              color: fontColor ?? AppColors.onPrimaryContainer,
            ),
        space = space ?? AppSpace.iconTextSmail,
        bgColor = bgColor ?? AppColors.surfaceVariant.withOpacity(0.3),
        bgColorChecked = bgColorChecked ?? AppColors.primaryContainer,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var ws = <Widget>[];
    ws.add(SizedBox(
      width: size,
      height: size,
      child: value == true ? iconChecked : icon,
    ).decorated(
      color: value == true ? bgColorChecked : bgColor,
      border: isBorder == true
          ? Border.all(
              color: borderColor ?? AppColors.outline,
              width: 1,
            )
          : null,
      borderRadius:
          size != null ? BorderRadius.all(Radius.circular(size! / 2)) : null,
    ));

    if (label != null) {
      ws.add(label!.paddingLeft(space ?? AppSpace.iconTextSmail));
    }

    return GestureDetector(
      onTap: onChanged != null ? () => onChanged!(!value) : null,
      child: ws.toRow(),
    );
  }
}
