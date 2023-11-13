import 'package:flutter/material.dart';
import 'package:orginone/components/widgets/image_widget.dart';

import 'icons.dart';

class XImage {
  XImage._();

  static Widget localImage(String name, {Size? size, BoxFit? fit}) {
    ///常规图
    String iconPath = (AIcons.icons['x']?[name]) ?? "";

    return ImageWidget(
      iconPath,
      fit: fit ?? BoxFit.cover,
      size: size?.width,
    );
  }
}
