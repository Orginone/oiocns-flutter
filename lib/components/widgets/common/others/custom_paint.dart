import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAssetsListItemButton extends CustomPainter {
  final Color backgroundColor;

  CustomAssetsListItemButton(this.backgroundColor);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    RRect rRect = RRect.fromLTRBR(
        0, 0, size.width, size.height, const Radius.circular(4));

    Path path = Path()..addRRect(rRect);

    drawLeftSemicircle(path, size);

    drawRightSemicircle(path, size);

    path.fillType = PathFillType.evenOdd;

    canvas.drawPath(path, paint);
  }

  void drawLeftSemicircle(Path path, Size size) {
    path.addArc(
        Rect.fromCenter(
          center: Offset(0, size.height / 2),
          width: 15.w,
          height: 15.w,
        ),
        pi * 3 / 2,
        pi);
  }

  void drawRightSemicircle(Path path, Size size) {
    path.addArc(
        Rect.fromCenter(
          center: Offset(size.width, size.height / 2),
          width: 15.w,
          height: 15.w,
        ),
        pi / 2,
        pi);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class CustomTopNotchShape extends ShapeBorder {
  @override
  //
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path();
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    Path path = Path();

    RRect rRect = RRect.fromRectAndRadius(rect, Radius.circular(8.w));

    path.addRRect(rRect);

    int maxR = (rect.width - 60.w) ~/ 25.w - 1;

    for (int i = 0; i < maxR; i++) {
      path.addArc(
          Rect.fromCenter(
            center: Offset(30.w + 30.w * i, 0),
            width: 20.w,
            height: 20.w,
          ),
          pi * 2,
          pi);
    }

    path.fillType = PathFillType.evenOdd;
    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    // TODO: implement paint
  }

  @override
  ShapeBorder scale(double t) {
    // TODO: implement scale
    throw UnimplementedError();
  }
}

class CustomTopBulgeShape extends ShapeBorder {
  @override
  // TODO: implement dimensions
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path();
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    Path path = Path();

    RRect rRect = RRect.fromRectAndCorners(rect,
        bottomLeft: Radius.circular(8.w), bottomRight: Radius.circular(8.w));
    path.addRRect(rRect);

    int maxR = (rect.width - 60.w) ~/ 25.w - 1;

    for (int i = 0; i < maxR; i++) {
      path.addArc(
          Rect.fromCenter(
            center: Offset(30.w + 30.w * i, 0),
            width: 15.w,
            height: 15.w,
          ),
          pi,
          pi);
    }

    path.fillType = PathFillType.evenOdd;
    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    // TODO: implement paint
  }

  @override
  ShapeBorder scale(double t) {
    // TODO: implement scale
    throw UnimplementedError();
  }
}
