import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'unified_colors.dart';

/// 横排 两端对齐的item
class TextSpaceBetween extends StatelessWidget {
  final String leftTxt;
  final String rightTxt;
  final bool isShowLine;
  final TextStyle leftStyle;
  final TextStyle rightStyle;

  const TextSpaceBetween({
    Key? key,
    this.leftTxt = '',
    this.rightTxt = '',
    this.isShowLine = false,
    this.leftStyle = const TextStyle(color: UnifiedColors.black3, fontSize: 16),
    this.rightStyle =
        const TextStyle(color: UnifiedColors.black6, fontSize: 16),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 15, 12, 15),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          leftTxt,
                          style: leftStyle,
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                              alignment: Alignment.centerRight,
                              child: Text(rightTxt, style: rightStyle)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 12, right: 12),
                child: Divider(
                  height: 2,
                  color: UnifiedColors.lineLight,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
