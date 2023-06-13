import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_item.dart';
import 'package:orginone/pages/chat/message_routers.dart';
import 'package:orginone/widget/common_widget.dart';

class MessageBreadcrumbNavItem
    extends BaseBreadcrumbNavItem<ChatBreadcrumbNav> {
  final PopupMenuItemSelected? onSelected;

  MessageBreadcrumbNavItem({
    required super.item,
    super.onTap,
    super.onNext,
    super.key,
    this.onSelected,
  });

  SettingController get setting => Get.find();

  @override
  Widget action() {
    if (item.type == ChatType.list) {
      return super.action();
    }
    return Obx((){
      PopupMenuItem popupMenuItem;
      if (setting.chat.isMostUsed(item.target!)) {
        popupMenuItem = const PopupMenuItem(
          value: "remove",
          child: Text("移除常用"),
        );
      } else {
        popupMenuItem = const PopupMenuItem(
          value: "set",
          child: Text("设为常用"),
        );
      }

      return CommonWidget.commonPopupMenuButton(items: [
        popupMenuItem,
      ], onSelected: onSelected);
    });
  }
}
