import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/button/gf_icon_button.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:orginone/widget/text_avatar.dart';


class WidgetUtil {
  static get defaultBackBtn => GFIconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_outlined,
          color: Colors.black,
          size: 32.w,
        ),
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
