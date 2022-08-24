import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../../config/custom_colors.dart';

class TextMessage extends StatelessWidget {
  final String? message;
  final TextDirection textDirection;

  const TextMessage(this.message, this.textDirection, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double half = 10.0;
    return Stack(
      textDirection: textDirection,
      children: [
        Align(
          child: Container(
            margin: EdgeInsets.fromLTRB(0, half, 0, 0),
            child: Material(
              color: CustomColors.seaBlue,
              shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(half)),
              child: SizedBox(
                width: half * 2,
                height: half,
              ),
            ),
          ),
        ),
        Container(
            constraints: const BoxConstraints(maxWidth: 180),
            padding: const EdgeInsets.all(10),
            margin: textDirection == TextDirection.ltr
                ? EdgeInsets.fromLTRB(half, 0, 0, 0)
                : EdgeInsets.fromLTRB(0, 0, half, 0),
            decoration: BoxDecoration(
                color: CustomColors.seaBlue,
                borderRadius: BorderRadius.all(Radius.circular(half))),
            child: Text(message ?? "")),
      ],
    );
  }
}
