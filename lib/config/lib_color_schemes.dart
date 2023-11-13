/*
 * @Descripttion: 
 * @version: 
 * @Author: congsir
 * @Date: 2022-11-24 16:11:11
 * @LastEditors: Please set LastEditors
 * @LastEditTime: 2022-12-08 15:55:28
 */
import 'package:flutter/material.dart';

const primary = const Color(0xff29a9ee);

///亮主题色
const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: primary,
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFDBE1FF),
  onPrimaryContainer: Color(0xFF001452),
  secondary: Color(0xFF595D71),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFDEE1F9),
  onSecondaryContainer: Color(0xFF161B2C),
  tertiary: Color(0xFF74546F),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFFFD7F7),
  onTertiaryContainer: Color(0xFF2C122A),
  error: Color(0xFFBA1B1B),
  errorContainer: Color(0xFFFFDAD4),
  onError: Color(0xFFFFFFFF),
  onErrorContainer: Color(0xFF410001),
  background: Color(0xFFFEFBFF),
  onBackground: Color(0xFF1B1B1F),
  surface: Color(0xFFFEFBFF),
  onSurface: Color(0xFFFFFFFF),
  surfaceVariant: Color(0xFFE2E1EC),
  onSurfaceVariant: Color(0xFF45464E),
  outline: Color(0xFF76767F),
  onInverseSurface: Color(0xFFF3F0F5),
  inverseSurface: Color(0xFF303033),
  inversePrimary: Color(0xFFB4C4FF),
  shadow: Color(0xFF000000),
);

///暗主题色
const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFFB4C4FF), //主色调
  onPrimary: Color(0xFF002683),
  primaryContainer: Color(0xFF0039B5),
  onPrimaryContainer: Color(0xFFDBE1FF),
  secondary: Color(0xFFC1C5DC),
  onSecondary: Color(0xFF2B3042),
  secondaryContainer: Color(0xFF424659),
  onSecondaryContainer: Color(0xFFDEE1F9),
  tertiary: Color(0xFFE3BADA),
  onTertiary: Color(0xFF432740),
  tertiaryContainer: Color(0xFF5B3D57),
  onTertiaryContainer: Color(0xFFFFD7F7),
  error: Color(0xFFFFB4A9),
  errorContainer: Color(0xFF930006),
  onError: Color(0xFF680003),
  onErrorContainer: Color(0xFFFFDAD4),
  background: Color(0xFF1B1B1F),
  onBackground: Color(0xFFE4E2E6),
  surface: Color(0xFF1B1B1F),
  onSurface: Color(0xFFE4E2E6),
  surfaceVariant: Color(0xFF45464E),
  onSurfaceVariant: Color(0xFFC6C6D0),
  outline: Color(0xFF90909A),
  onInverseSurface: Color(0xFF1B1B1F),
  inverseSurface: Color(0xFFE4E2E6),
  inversePrimary: Color(0xFF2954CE),
  shadow: Color(0xFF000000),
);
