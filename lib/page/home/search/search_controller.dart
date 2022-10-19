import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/api/company_api.dart';

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
  applications("应用"),
  units("单位");

  const SearchItem(this.name);

  final String name;
}

class SearchController extends GetxController
    with GetSingleTickerProviderStateMixin {
  Logger logger = Logger("SearchController");
  List<dynamic> searchResults = [];
  ScrollController scrollController = ScrollController();
  late TabController tabController;
  late List<SearchItem> searchItems;

  @override
  void onInit() {
    searchItems = Get.arguments ?? SearchItem.values;
    tabController = TabController(length: searchItems.length, vsync: this);
    super.onInit();
  }

  Future<void> searchingCallback(String filter) async {
    switch (searchItems[tabController.index]) {
      case SearchItem.friends:
        break;
      case SearchItem.applications:
        break;
      case SearchItem.comprehensive:
        break;
      case SearchItem.cohorts:
        break;
      case SearchItem.messages:
        break;
      case SearchItem.documents:
        break;
      case SearchItem.logs:
        break;
      case SearchItem.labels:
        break;
      case SearchItem.functions:
        break;
      case SearchItem.departments:
        break;
      case SearchItem.publicCohorts:
        break;
      case SearchItem.units:
        searchResults = await CompanyApi.searchCompanys(filter);
        update();
        break;
    }
  }
}
