import 'dart:math';

import 'package:flutter/material.dart';

class ClipCircle extends ClipPath {
  ClipCircle({
    Key? key,
    CustomClipper<Path>? clipper,
    Clip clipBehavior = Clip.antiAlias,
    Widget? child,
  }) : super(
    clipper: clipper ?? _CircleClipper(),
    clipBehavior: clipBehavior,
    child: child,
  );
}

class _CircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    //x坐标为0.0 y坐标为手机高度一半
    //到x坐标为手机宽度 到 手机宽度的一半减去100 达到斜线的结果
    //到x坐标为手机宽度 到 y坐标为手机宽度
    //完成
    var halfWidth = size.width / 2;
    var halfHeight = size.height / 2;
    var path = Path()
      ..addOval(
        Rect.fromCircle(
          center: Offset(
            halfWidth,
            halfHeight,
          ),
          radius: min(halfWidth, halfHeight),
        ),
      )
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
