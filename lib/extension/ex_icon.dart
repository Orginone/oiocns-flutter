import 'package:flutter/material.dart';

/// 扩展 Icon
extension ExIcon<T extends Icon> on T {
  T copyWith({
    double? size,
    Color? color,
    String? semanticLabel,
    TextDirection? textDirection,
  }) =>
      Icon(
        icon,
        color: color ?? this.color,
        size: size ?? this.size,
        semanticLabel: semanticLabel ?? this.semanticLabel,
        textDirection: textDirection ?? this.textDirection,
      ) as T;

  /// 尺寸
  T iconSize(double size) => copyWith(size: size);

  /// 颜色
  T iconColor(Color color) => copyWith(color: color);
}
