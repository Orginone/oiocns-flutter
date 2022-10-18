import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VoicePainter extends CustomPainter {
  final double amplitude;
  final double centerY;
  final double width;

  const VoicePainter({
    required this.centerY,
    required this.width,
    this.amplitude = 100.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var count = 21;
    var margin = 5.0.w;
    var useWidth = width - margin * 2;
    var averageWidth = useWidth / count / 2;

    for (var a = 0; a < 4; a++) {
      var path = Path();
      path.moveTo(margin, centerY);
      var i = 0;
      var isOdd = false;
      while (i < count * 2) {
        var multiple = ((count ~/ 2) - i).abs();
        if (multiple == 0){
          multiple = 2;
        }
        path.cubicTo(
          averageWidth * i,
          centerY,
          averageWidth * (i + 1),
          centerY + (isOdd ? amplitude / multiple : -amplitude / multiple),
          averageWidth * (i + 2),
          centerY,
        );
        i = i + 2;
        isOdd = !isOdd;
      }
      canvas.drawPath(
          path,
          Paint()
            ..color = a == 0 ? Colors.white : Colors.white.withAlpha(50)
            ..strokeWidth = a == 0 ? 3.0 : 2.0
            ..maskFilter = const MaskFilter.blur(
              BlurStyle.solid,
              5,
            )
            ..style = PaintingStyle.stroke);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
