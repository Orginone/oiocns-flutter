import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// 扩展 String
extension ExString on String {
  /// 生成 Color
  Color get toColor {
    return Color(int.parse(this, radix: 16) | 0xFF000000);
  }

  /// 生成 MaterialColor
  Color get toMaterialColor {
    Color color = toColor;

    List<double> strengths = <double>[.05];
    Map<int, Color> swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }

  /// 清除 html 标签
  String get clearHtml {
    return replaceAll(RegExp(r'<[^>]*>'), '');
  }

  /// 格式化日期 - yyyy-MM-dd
  String get dateFormatOfyyyyMMdd {
    var date = DateTime.parse(this);
    return DateFormat('yyyy-MM-dd').format(date);
  }
}
