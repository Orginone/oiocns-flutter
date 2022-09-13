import 'package:flutter/material.dart';

import '../config/custom_colors.dart';
import '../util/string_util.dart';

enum TextAvatarType { space, chat }

const double defaultWidth = 40;
const double defaultHeight = 40;
const double defaultRadius = 5;
const EdgeInsets defaultInsets = EdgeInsets.fromLTRB(5, 10, 5, 0);
const Color defaultBgColor = CustomColors.blue;

class TextAvatar extends StatelessWidget {
  final TextAvatarType textAvatarType;
  final String avatarName;
  final double width;
  final double radius;
  final EdgeInsets padding;
  final Color bgColor;

  TextAvatar(
      {Key? key,
      required String avatarName,
      required TextAvatarType type,
      radius = defaultRadius,
      this.width = defaultWidth,
      this.padding = defaultInsets,
      this.bgColor = defaultBgColor})
      : avatarName = _getAvatarName(avatarName, type),
        radius = _getRadius(width, radius, type),
        textAvatarType = type,
        super(key: key);

  static String _getAvatarName(String avatarName, TextAvatarType type) {
    switch (type) {
      case TextAvatarType.space:
        return StringUtil.getPrefixChars(avatarName, count: 1);
      case TextAvatarType.chat:
        return StringUtil.getPrefixChars(avatarName, count: 2);
    }
  }

  static double _getRadius(double width, double radius, TextAvatarType type) {
    switch (type) {
      case TextAvatarType.space:
        return width / 2;
      case TextAvatarType.chat:
        return radius;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: padding,
        child: Container(
          alignment: Alignment.center,
          width: width,
          height: width,
          decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.all(Radius.circular(radius))),
          child: Text(avatarName, style: const TextStyle(color: Colors.white)),
        ));
  }
}
