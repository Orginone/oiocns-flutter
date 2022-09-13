import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/button/gf_icon_button.dart';
import 'package:getwidget/types/gf_button_type.dart';

import '../config/custom_colors.dart';

class WidgetUtil {
  static get defaultBackBtn => GFIconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Get.back(),
        type: GFButtonType.transparent,
      );
}
