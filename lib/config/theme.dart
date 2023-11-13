/*
 * @Descripttion: 
 * @version: 
 * @Author: congsir
 * @Date: 2022-11-24 16:13:25
 * @LastEditors: Please set LastEditors
 * @LastEditTime: 2022-12-08 16:01:13
 */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orginone/config/lib_color_schemes.dart';

import 'index.dart';

/// 主题
class AppTheme {
  /// 亮色
  static ThemeData light = ThemeData(
    colorScheme: lightColorScheme,
    fontFamily: "Montserrat",

    appBarTheme: AppBarTheme(
      // appBar 暗色 , 和主题色相反
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      centerTitle: true,
      // 背景透明
      backgroundColor: AppColors.primary,
      // 取消阴影
      elevation: 0,
      // 图标样式
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      // 标题
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
    ), // appBar 暗色 , 和主题色相反
  );

  /// 暗色
  static ThemeData dark = ThemeData(
    colorScheme: darkColorScheme,
    fontFamily: "Montserrat",
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.light, // appBar 亮色 , 和主题色相反
    ),
  );
}
