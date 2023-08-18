/*
 * @Descripttion: 
 * @version: 
 * @Author: congsir
 * @Date: 2022-11-24 17:05:48
 * @LastEditors: Please set LastEditors
 * @LastEditTime: 2022-11-24 17:06:01
 */
import 'package:flutter/material.dart';

/// 间距
class GYSpace {
  /// 按钮
  static double get button => 5;

  /// 按钮
  static double get sectionH => 40;

  /// 按钮
  static double get buttonHeight => 50;
  static double get normalButtonHeight => 36;

  /// 卡片内 - 12 上下左右
  static double get card => 15;

  /// 输入框 - 10, 10 上下，左右
  static EdgeInsetsGeometry get edgeInput =>
      const EdgeInsets.symmetric(vertical: 10, horizontal: 10);

  /// 列表视图
  static double get listView => 5;

  /// 列表行 - 10 上下
  static double get listRow => 10;

  /// 列表项
  static double get listItem => 8;

  /// 页面内 - 16 左右
  static double get page => 16;

  /// 段落 - 24
  static double get paragraph => 24;

  /// 标题内容 - 10
  static double get titleContent => 10;

  /// 图标文字 - 15
  static double get iconTextSmail => 5;
  static double get iconTextMedium => 10;
  static double get iconTextLarge => 15;
}
