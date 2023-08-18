/*
 * @Descripttion: 
 * @version: 
 * @Author: congsir
 * @Date: 2022-11-24 17:05:06
 * @LastEditors: 
 * @LastEditTime: 2022-11-24 17:05:17
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 字体样式
class GYTextStyles {
  static TextStyle? get bodyLarge => Get.textTheme.bodyLarge;
  static TextStyle? get bodyMedium => Get.textTheme.bodyMedium;
  static TextStyle? get bodySmall => Get.textTheme.bodySmall;

  static TextStyle? get bodyText1 => Get.textTheme.bodyLarge;
  static TextStyle? get bodyText2 => Get.textTheme.bodyMedium;

  static TextStyle? get button => Get.textTheme.labelLarge;
  static TextStyle? get caption => Get.textTheme.bodySmall;

  static TextStyle? get displayLarge => Get.textTheme.displayLarge;
  static TextStyle? get displayMedium => Get.textTheme.displayMedium;
  static TextStyle? get displaySmall => Get.textTheme.displaySmall;

  static TextStyle? get headline1 => Get.textTheme.displayLarge;
  static TextStyle? get headline2 => Get.textTheme.displayMedium;
  static TextStyle? get headline3 => Get.textTheme.displaySmall;
  static TextStyle? get headline4 => Get.textTheme.headlineMedium;
  static TextStyle? get headline5 => Get.textTheme.headlineSmall;
  static TextStyle? get headline6 => Get.textTheme.titleLarge;

  static TextStyle? get headlineLarge => Get.textTheme.headlineLarge;
  static TextStyle? get headlineMedium => Get.textTheme.headlineMedium;
  static TextStyle? get headlineSmall => Get.textTheme.headlineSmall;

  static TextStyle? get labelLarge => Get.textTheme.labelLarge;
  static TextStyle? get labelMedium => Get.textTheme.labelMedium;
  static TextStyle? get labelSmall => Get.textTheme.labelSmall;

  static TextStyle? get overline => Get.textTheme.labelSmall;
  static TextStyle? get subtitle1 => Get.textTheme.titleMedium;
  static TextStyle? get subtitle2 => Get.textTheme.titleSmall;

  static TextStyle? get titleLarge => Get.textTheme.titleLarge;
  static TextStyle? get titleMedium => Get.textTheme.titleMedium;
  static TextStyle? get titleSmall => Get.textTheme.titleSmall;
}
