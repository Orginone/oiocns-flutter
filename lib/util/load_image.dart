import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'icons.dart';

class XImage {
  XImage._();

  static Image localImage(String name, {Size? size, BoxFit? fit}) {
    ///常规图
    String iconPath = (AIcons.icons['x']?[name]) ?? "";

    if (size == null) {
      return Image.asset(
        iconPath,
        fit: (fit ?? BoxFit.cover),
      );
    } else {
      return Image.asset(
        iconPath,
        width: size.width,
        height: size.height,
        fit: (fit ?? BoxFit.cover),
      );
    }
  }

  ///加载网络图片
  static Widget netImage(
      {String placeholder = AIcons.placeholder,
      String? url,
      Size? size,
      BoxFit? fit,
      Alignment? alignment}) {
    if (url == null || url == "") {
      return XImage.localImage(placeholder, size: size);
    }
    double width = size != null ? size.width : double.infinity;
    double height = size != null ? size.height : double.infinity;
    alignment ??= Alignment.center;
    return Container(
      constraints: BoxConstraints.expand(width: width, height: height),
      child: CachedNetworkImage(
        imageUrl: url,
        placeholder: (context, url) => localImage(placeholder),
        errorWidget: (context, url, error) => localImage(placeholder),
        width: width,
        height: height,
        fit: fit ?? BoxFit.cover,
        alignment: alignment,
      ),
    );
  }

  ///加载网络图片,宽度自动充满
  static Widget netFitWidth(String url) {
    return Image(
      image: CachedNetworkImageProvider(url),
      fit: BoxFit.fitWidth,
    );
  }

  ///加载网络图片 四个圆角弧度一样
  static Widget netImageRadiusAll(
      {String placeholder = AIcons.placeholder,
      String? url,
      Size? size,
      BoxFit? fit,
      double? radius}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? 0),
      child: netImage(placeholder: placeholder, url: url, size: size, fit: fit),
    );
  }

  ///加载网络图片 四角可设置不同弧度
  static Widget netImageRadius(
      {String placeholder = AIcons.placeholder,
      String? url,
      Size? size,
      BoxFit? fit,
      double? topLeft,
      double? topRight,
      double? bottomLeft,
      double? bottomRight}) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(topLeft ?? 0),
          topRight: Radius.circular(topRight ?? 0),
          bottomLeft: Radius.circular(bottomLeft ?? 0),
          bottomRight: Radius.circular(bottomRight ?? 0)),
      child: netImage(placeholder:placeholder, url: url, size: size, fit: fit),
    );
  }

  ///加载网络图片 圆形
  static Widget netImageCircle(
      {String placeholder = AIcons.placeholder,
      String? url,
      Size? size,
      BoxFit? fit}) {
    return ClipOval(
      child: netImage(placeholder:placeholder, url: url, size: size, fit: fit),
    );
  }
}
