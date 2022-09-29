import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/button/gf_icon_button.dart';
import 'package:getwidget/types/gf_button_type.dart';

import '../component/text_avatar.dart';

class WidgetUtil {
  static get defaultBackBtn => GFIconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Get.back(),
        type: GFButtonType.transparent,
      );


  static double getRadius(double width, double radius, TextAvatarType type) {
    switch (type) {
      case TextAvatarType.space:
        return width / 2;
      case TextAvatarType.chat:
      case TextAvatarType.avatar:
        return radius;
    }
  }
}
