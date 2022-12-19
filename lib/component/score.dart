import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/component/unified_colors.dart';

const double defaultSize = 20;

class Score extends StatelessWidget {
  final int total;
  final int actual;
  final double size;

  const Score({
    Key? key,
    required this.total,
    required this.actual,
    this.size = defaultSize,
  })  : assert(total >= actual, "总数量必须大于实际数量"),
        assert(total > 0, "总数量必须大于 0"),
        assert(actual >= 0, "实际数量必须大于等于 0 "),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return _body;
  }

  get _body {
    List<Widget> scores = [];
    for (int i = 0; i < total; i++) {
      if (i < actual) {
        scores.add(Icon(
          Icons.star,
          color: UnifiedColors.starColor,
          size: size,
        ));
      } else {
        scores.add(Icon(
          Icons.star_border,
          color: UnifiedColors.cardBorder,
          size: size,
        ));
      }
      scores.add(Padding(padding: EdgeInsets.only(left: 4.w)));
    }
    return Row(children: scores);
  }
}
