import 'package:flutter/material.dart';
import '../index.dart';

/// 图标文字组件
class IconTextWidget extends StatelessWidget {
  // 图标
  final Widget? icon;

  // 文字
  final String? text;

  // 图标数据
  final IconData? iconData;

  // 图标尺寸
  final double? iconSize;

  // 文字尺寸
  final double? fontSize;

  // 颜色
  final Color? color;

  // 间距
  final double? iconPadding;

  //  构造函数
  const IconTextWidget({
    Key? key,
    this.icon,
    this.text,
    this.iconData,
    this.iconSize,
    this.color,
    this.fontSize,
    this.iconPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return <Widget>[
      // 图标
      icon?.paddingRight(iconPadding ?? AppSpace.iconTextSmail) ??
          IconWidget.icon(
            iconData ?? Icons.star,
            size: iconSize ?? 12,
            color: color ?? AppColors.primary,
          ).paddingRight(iconPadding ?? AppSpace.iconTextSmail),

      // 文字
      TextWidget.body2(
        text ?? '',
        size: fontSize ?? 12,
      ),
    ]
        .toRow(
          mainAxisSize: MainAxisSize.min,
        )
        .fittedBox(
          fit: BoxFit.none,
          clipBehavior: Clip.hardEdge,
        );
  }
}
