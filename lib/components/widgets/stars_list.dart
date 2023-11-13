/*
 * @Descripttion: 
 * @version: 
 * @Author: congsir
 * @Date: 2022-11-29 19:35:41
 * @LastEditors: 
 * @LastEditTime: 2022-11-30 11:03:03
 */
import 'package:flutter/material.dart';
import 'package:orginone/common/index.dart';
import 'package:orginone/config/index.dart';

/// 星级列表组件
class StarsListWidget extends StatelessWidget {
  /// 点击事件
  final Function(int value)? onTap;

  /// 图标 data
  final IconData? iconData;

  /// 星级数量
  final int starNum;

  /// 选中的星级
  final int value;

  /// 星级大小
  final double? size;

  // 颜色
  final Color? color;

  // 选中颜色
  final Color? selectedColor;

  // 元素间距
  final double? spacing;

  // 行间距
  final double? runSpacing;

  // 构造
  StarsListWidget({
    Key? key,
    this.onTap,
    this.size = 24,
    this.iconData,
    Color? color,
    Color? selectedColor,
    this.spacing = 5,
    this.runSpacing = 5,
    this.starNum = 5,
    this.value = 0,
  })  : color = color ?? AppColors.surfaceVariant,
        selectedColor = selectedColor ?? AppColors.primary,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return <Widget>[
      for (var i = 1; i <= starNum; i++)
        IconWidget.icon(
          iconData ?? Icons.star,
          size: size ?? 12,
          color: i <= value ? selectedColor : color,
        ).onTap(() {
          if (value == 1 && i == value) {
            onTap?.call(0);
          } else {
            onTap?.call(i);
          }
        }),
    ].toWrap(
      spacing: spacing ?? AppSpace.listItem,
      runSpacing: runSpacing ?? AppSpace.listRow,
    );
  }
}
