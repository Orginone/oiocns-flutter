import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/button/gf_icon_button.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:orginone/component/popup_func.dart';

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

  static void showMsg({
    required BuildContext context,
    required Widget child,
    required double height,
  }) {

    // 获取屏幕渲染矩形
    final RenderBox box = context.findRenderObject()! as RenderBox;
    final overlay = Navigator.of(context).overlay!.context;
    final RenderBox overlayBox = overlay.findRenderObject()! as RenderBox;

    const Offset offset = Offset.zero;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        box.localToGlobal(offset, ancestor: overlayBox),
        box.localToGlobal(box.size.bottomRight(Offset.zero) + offset,
            ancestor: overlayBox),
      ),
      Offset.zero & overlayBox.size,
    );
    showMenu<PopupFunc>(
      context: context,
      items: [PopupFunc(func: child, height: height)],
      position: position,
    );
  }
}
