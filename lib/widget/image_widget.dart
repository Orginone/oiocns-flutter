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

  const ImageWidget(
  this.path,{Key? key, this.width, this.height, this.color, this.fit = BoxFit
          .contain}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(path is String){
      if(path.contains('http')){
        return network();
      }
      if(path.split('.').last.toLowerCase() == 'svg'){
       return svg();
      }else{
        return asset();
      }
    }
    if(path is File){
      return file();
    }
    if(path is Uint8List){
      return memory();
    }
    if(path is IconData){
      return icon();
    }
    return asset();
  }

  Widget svg() {
    return SvgPicture.asset(
        path, fit: fit, width: width, height: height, color: color,);
  }

  Widget asset(){
    return Image.asset(path, fit: fit, width: width, height: height, color: color);
  }

  Widget network(){
    return Image.network(path, fit: fit, width: width, height: height, color: color);
  }

  Widget memory(){
    return Image.memory(path, fit: fit, width: width, height: height, color: color);
  }

  Widget file(){
    return Image.file(path, fit: fit, width: width, height: height, color: color);
  }

  Widget icon(){
    return Icon(path,size: max(width??24.w, height??24.h),color: color,);
  }
}
