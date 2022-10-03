import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/component/unified_text_style.dart';

import '../../../../../config/custom_colors.dart';
import '../../../../../util/string_util.dart';

double defaultWidth = 10.w;
const String defaultMsg = "";

class TextMessage extends StatelessWidget {
  final String? message;
  final TextDirection textDirection;

  const TextMessage(this.textDirection, {Key? key, this.message = defaultMsg})
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
            borderRadius: BorderRadius.all(Radius.circular(defaultWidth)),
          ),
          child: Text(
            message ?? "",
            style: text14Bold,
          ),
        ),
      ],
    );
  }
}
