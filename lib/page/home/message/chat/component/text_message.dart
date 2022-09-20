import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../component/unified_edge_insets.dart';
import '../../../../../config/custom_colors.dart';

double defaultWidth = 10.w;

class TextMessage extends StatelessWidget {
  final String? message;
  final TextDirection textDirection;

  const TextMessage(this.message, this.textDirection, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      textDirection: textDirection,
      children: [
        Align(
          child: Container(
            margin: EdgeInsets.only(top: defaultWidth * 1.2),
            child: Material(
              color: CustomColors.seaBlue,
              shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(defaultWidth)),
              child: SizedBox(
                width: defaultWidth * 2,
                height: defaultWidth,
              ),
            ),
          ),
        ),
        Container(
            constraints: BoxConstraints(maxWidth: 180.w),
            padding: EdgeInsets.all(defaultWidth),
            margin: textDirection == TextDirection.ltr
                ? EdgeInsets.only(left: defaultWidth, top: defaultWidth / 2)
                : EdgeInsets.only(right: defaultWidth, top: defaultWidth / 2),
            decoration: BoxDecoration(
                color: CustomColors.seaBlue,
                borderRadius: BorderRadius.all(Radius.circular(defaultWidth))),
            child: Text(message ?? "")),
      ],
    );
  }
}
