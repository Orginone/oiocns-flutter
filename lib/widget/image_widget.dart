import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ImageWidget extends StatelessWidget {
  final dynamic path;

  final double? width;

  final double? height;

  final Color? color;

  final BoxFit fit;

  final bool circular;

  final bool gaplessPlayback;

  const ImageWidget(this.path,
      {Key? key,
      this.width,
      this.height,
      this.color,
      this.fit = BoxFit.contain,
      this.circular = false, this.gaplessPlayback = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (path is String) {
      if (path.contains('http')) {
        child = network();
      }
      if (path.split('.').last.toLowerCase() == 'svg') {
        child = svg();
      } else {
        child = asset();
      }
    } else if (path is File) {
      child = file();
    } else if (path is Uint8List) {
      child = memory();
    } else if (path is IconData) {
      child = icon();
    } else {
      child = asset();
    }

    if (circular) {
      child = ClipOval(
        child: child,
      );
    }
    return child;
  }

  Widget svg() {
    return SvgPicture.asset(
        path, fit: fit, width: width, height: height, color: color,);
  }

  Widget asset(){
    return Image.asset(path, fit: fit, width: width, height: height, color: color,gaplessPlayback: gaplessPlayback,);
  }

  Widget network(){
    return Image.network(path, fit: fit, width: width, height: height, color: color,gaplessPlayback: gaplessPlayback);
  }

  Widget memory(){
    return Image.memory(path, fit: fit, width: width, height: height, color: color,gaplessPlayback: gaplessPlayback);
  }

  Widget file(){
    return Image.file(path, fit: fit, width: width, height: height, color: color,gaplessPlayback: gaplessPlayback);
  }

  Widget icon(){
    return Icon(path,size: max(width??24.w, height??24.h),color: color,);
  }
}
