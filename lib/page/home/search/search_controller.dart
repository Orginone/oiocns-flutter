import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/api/company_api.dart';
import 'package:orginone/api/person_api.dart';

import '../../../api_resp/target_resp.dart';

enum SearchItem {
  comprehensive("综合", []),
  friends("好友", [FunctionPoint.addFriends]),
  cohorts("群组", []),
  messages("消息", []),
  documents("文档", []),
  logs("日志", []),
  labels("文本", []),
  functions("功能", []),
  departments("部门", []),
  publicCohorts("公开群组", []),
  applications("应用", []),
  units("单位", []);

  const SearchItem(this.name, this.functionPoint);

  final String name;
  final List<FunctionPoint> functionPoint;
}

enum FunctionPoint {
  addFriends("添加好友");

  const FunctionPoint(this.functionName);

  final String functionName;
}

class SearchController extends GetxController
    with GetSingleTickerProviderStateMixin {
  Logger logger = Logger("SearchController");

  late TabController tabController;
  late List<SearchItem> searchItems;
  FunctionPoint? functionPoint;
  ScrollController scrollController = ScrollController();

  // 搜索的一些结果
  SearchParams<TargetResp>? personRes;
  SearchParams<TargetResp>? companyRes;

  // 输入提示
  String? placeholder;

  @override
  void onInit() {
    Map<String, dynamic> args = Get.arguments ?? {};
    searchItems = args["items"] ?? SearchItem.values;
    functionPoint = args["point"];
    placeholder = args["placeholder"];

    tabController = TabController(length: searchItems.length, vsync: this);
    super.onInit();
  }

  Future<void> searchingCallback(String filter) async {
    switch (searchItems[tabController.index]) {
      case SearchItem.friends:
        personRes ??= SearchParams();
        var pageResp = await PersonApi.searchPersons(
          keyword: filter,
          limit: personRes!.limit,
          offset: personRes!.offset,
        );
        var result = pageResp.result;
        personRes!.offset = result.length;
        personRes!.searchResults = result;
        update();
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
        companyRes ??= SearchParams();
        var pageResp = await CompanyApi.searchCompanys(
          keyword: filter,
          limit: companyRes!.limit,
          offset: companyRes!.offset,
        );
        var result = pageResp.result;
        companyRes!.offset = result.length;
        companyRes!.searchResults = result;
        update();
        break;
    }
  }
}

class SearchParams<T> {
  List<T> searchResults = [];
  int limit = 20;
  int offset = 0;
}
