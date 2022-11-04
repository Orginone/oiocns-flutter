import 'package:flutter/material.dart';

enum TextAvatarType { space, chat, avatar }

const double defaultWidth = 40;
const double defaultRadius = 5;
const Color defaultBgColor = Colors.blueAccent;
const EdgeInsets defaultMargin = EdgeInsets.zero;
const TextStyle defaultTextStyle = TextStyle(
  fontSize: 16,
  color: Colors.white,
  fontWeight: FontWeight.bold,
);

class TextAvatar extends StatelessWidget {
  final String avatarName;
  final double width;
  final double radius;
  final EdgeInsets? margin;
  final Color bgColor;
  final TextStyle textStyle;
  final Widget? status;

  const TextAvatar({
    Key? key,
    required this.avatarName,
    this.radius = defaultRadius,
    this.width = defaultWidth,
    this.margin = defaultMargin,
    this.bgColor = defaultBgColor,
    this.textStyle = defaultTextStyle,
    this.status,
  }) : super(key: key);

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
