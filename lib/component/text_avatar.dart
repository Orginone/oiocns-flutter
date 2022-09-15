import 'package:flutter/material.dart';

import '../config/custom_colors.dart';
import '../util/string_util.dart';

enum TextAvatarType { space, chat, avatar }

const double defaultWidth = 40;
const double defaultRadius = 5;
const Color defaultBgColor = Colors.blueAccent;
const EdgeInsets defaultMargin = EdgeInsets.zero;
const TextStyle defaultTextStyle =
    TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold);

class TextAvatar extends StatelessWidget {
  final TextAvatarType textAvatarType;
  final String avatarName;
  final double width;
  final double radius;
  final EdgeInsets? margin;
  final Color bgColor;
  final TextStyle textStyle;
  final Widget? status;

  TextAvatar(
      {Key? key,
      required String avatarName,
      required TextAvatarType type,
      radius = defaultRadius,
      this.width = defaultWidth,
      this.margin = defaultMargin,
      this.bgColor = defaultBgColor,
      this.textStyle = defaultTextStyle,
      this.status})
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
      case TextAvatarType.avatar:
        return StringUtil.getPrefixChars(avatarName, count: 1);
    }
  }

  static double _getRadius(double width, double radius, TextAvatarType type) {
    switch (type) {
      case TextAvatarType.space:
        return width / 2;
      case TextAvatarType.chat:
      case TextAvatarType.avatar:
        return radius;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: width,
      height: width,
      margin: margin,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.all(Radius.circular(radius)),
      ),
      child: Stack(
        children: [
          Align(
            alignment: AlignmentDirectional.topEnd,
            child: Container(margin: const EdgeInsets.all(2), child: status),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              avatarName,
              style: textStyle,
            ),
          )
        ],
      ),
    );
  }
}
