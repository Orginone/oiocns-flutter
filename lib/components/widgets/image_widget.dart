import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:orginone/common/index.dart';
import 'package:orginone/utils/index.dart';

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
      this.circular = false,
      this.gaplessPlayback = false,
      this.httpHeaders,
      this.radius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (path == null) {
      return const SizedBox();
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

    if (radius != null) {
      child = ClipRRect(
        borderRadius: BorderRadius.circular(radius!),
        child: child,
      );
    } else if (circular) {
      child = ClipOval(
        child: child,
      );
    }
    return child;
  }

  Widget svg() {
    return SvgPicture.asset(
      path,
      fit: fit,
      width: size,
      height: size,
      color: color,
    );
  }

  Widget asset() {
    return Image.asset(
      path,
      fit: fit,
      width: size,
      height: size,
      color: color,
      gaplessPlayback: gaplessPlayback,
    );
  }

  Widget network() {
    // String a =
    //     'https://ts1.cn.mm.bing.net/th/id/R-C.79f51ff10efd5b83802e31152f19e1e1?rik=VFCY3zzecv8j2w&riu=http%3a%2f%2fabc.2008php.com%2f2019_Website_appreciate%2f2019-03-21%2f20190321205013r9uwk.jpg&ehk=D6ZmSPTqfBdk5ue51OOnY5EVjSC49lkGeVyyrlrUObk%3d&risl=&pid=ImgRaw&r=0';
    return CachedNetworkImage(
      fit: fit,
      width: size,
      height: size,
      color: color,
      imageUrl: path,
      httpHeaders: httpHeaders,
      errorWidget: (context, url, error) {
        LogUtil.d('CachedNetworkImage -error ');
        LogUtil.d(error);
        return Icon(
          Icons.broken_image,
          color: Colors.grey.shade300,
          size: 50.w,
        );
      },
      placeholder: (context, url) => const SizedBox(
        width: 80,
        height: 80,
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 1,
          ),
        ),
      ),
    );
  }

  Widget network1() {
    return XImageWidget.url(
      path,
      fit: fit,
      width: size,
      height: size,
    ).onTap(
      () {},
    );
  }

  Widget memory() {
    return Image.memory(
      path,
      fit: fit,
      width: size,
      height: size,
      color: color,
      gaplessPlayback: gaplessPlayback,
      errorBuilder: (context, error, stackTrace) {
        return Icon(
          Icons.broken_image,
          color: Colors.grey.shade300,
          size: size,
        );
      },
    );
  }

  Widget file() {
    return Image.file(path,
        fit: fit,
        width: size,
        height: size,
        color: color,
        gaplessPlayback: gaplessPlayback);
  }

  Widget icon() {
    return Icon(
      path,
      size: max(size ?? 24.w, size ?? 24.h),
      color: iconColor,
    );
  }
}
