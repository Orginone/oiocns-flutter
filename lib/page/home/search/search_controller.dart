import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';

enum SearchItem {
  comprehensive("综合"),
  friends("好友"),
  cohorts("群组"),
  messages("消息"),
  documents("文档"),
  logs("日志"),
  labels("文本"),
  functions("功能"),
  departments("部门"),
  publicCohorts("公开群组"),
  applications("应用");

  const SearchItem(this.name);

  final String name;
}

class SearchController extends GetxController
    with GetSingleTickerProviderStateMixin {
  Logger logger = Logger("SearchController");

  late TabController tabController;
  late List<SearchItem> searchItems;

  @override
  void onInit() {
    searchItems = Get.arguments ?? SearchItem.values;
    tabController = TabController(length: searchItems.length, vsync: this);
    super.onInit();
  }

  Future<void> searchingCallback(String filter) async {

  }
}
