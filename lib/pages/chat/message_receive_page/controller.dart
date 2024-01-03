import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/chat/message.dart';

class MessageReceiveController extends GetxController
    with GetSingleTickerProviderStateMixin {
  MessageReceiveController();
  List<XTarget> get readMember => Get.arguments['readMember'] ?? [];
  List<XTarget> get unreadMember => Get.arguments['unreadMember'] ?? [];
  List<IMessageLabel> get labels => Get.arguments['labels'] ?? [];

  late TabController tabController;

  final List<String> tabs = ['已读', '未读'];
  _initData() {
    update(["message_receive_page"]);
  }

  void onTap() {}

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
