import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ImageWidget extends StatelessWidget {
  final dynamic path;

  final double? size;

  final Color? color;

  final Color? iconColor;

  final BoxFit fit;

  final bool circular;

  final double? radius;

  final bool gaplessPlayback;

  final Map<String, String>? httpHeaders;

  const ImageWidget(this.path,
      {Key? key,
      this.size,
      this.color,
        this.iconColor,
      this.fit = BoxFit.contain,
      this.circular = false, this.gaplessPlayback = false, this.httpHeaders, this.radius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(path == null){
      return SizedBox();
    }
    Widget child;
    if (path is String) {
      if (path.contains('http')) {
        child = network();
      } else if (path.split('.').last.toLowerCase() == 'svg') {
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

    if (radius!=null) {
      child = ClipRRect(
        borderRadius: BorderRadius.circular(radius!),
        child: child,
      );
    }else if (circular) {
      child = ClipOval(
        child: child,
      );
    }
    return child;
  }

  Widget svg() {
    return SvgPicture.asset(
        path, fit: fit, width: size, height: size, color: color,);
  }

  Widget asset(){
    return Image.asset(path, fit: fit, width: size, height: size, color: color,gaplessPlayback: gaplessPlayback,);
  }

  Widget network(){
    return CachedNetworkImage(fit: fit, width: size, height: size, color: color, imageUrl: path,httpHeaders: httpHeaders,placeholder: (context,str){
      return Container(width: size,height: size,color: Colors.white,);
    },);
  }

  Widget memory(){
    return Image.memory(path, fit: fit, width: size, height: size, color: color,gaplessPlayback: gaplessPlayback);
  }

  Widget file(){
    return Image.file(path, fit: fit, width: size, height: size, color: color,gaplessPlayback: gaplessPlayback);
  }

  Widget icon(){
    return Icon(path,size: max(size??24.w, size??24.h),color: iconColor,);
  }
}
